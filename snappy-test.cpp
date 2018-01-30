#include <snappy.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <iostream>
#include <fstream>

size_t read_file(const char *filename, char **pbuf)
{
	std::ifstream in(filename, std::ios::in);
	int ret;
	size_t size = 0;

	if (!in.is_open()) {
		std::cout << "file " << filename << " open failed" << std::endl;
		return -1;
	}

	in.seekg(0, std::ios::end);
	size = in.tellg();
	in.seekg(0, std::ios::beg);

	char *buf = (char *)malloc(size);
	if (buf == NULL) {
		std::cout << "malloc failed" << size << "bytes" << std::endl;
		return -1;
	}

	in.read(buf, size);

	*pbuf = buf;
	in.close();

	return size;
}

int write_file(const char *filename, const char *buf, size_t size)
{
	std::ofstream out(filename, std::ios::out);
	if (!out.is_open()) {
		std::cout << "file " << filename << " open failed" << std::endl;
		return -1;
	}

	out.write(buf, size);
	out.close();

	return 0;
}

int main(int argc, char *argv[])
{
	char *buf;
	size_t ret;

	if (argc < 4) {
		fprintf(stderr, "usage: %s <op> <infile> <outfile>\n", argv[0]);
		fprintf(stderr, "\top:\n");
		fprintf(stderr, "\t\t-c: compress\n");
		fprintf(stderr, "\t\t-d: uncompress\n");
		return -1;
	}

	ret = read_file(argv[2], &buf);
	if (ret <= 0) {
		std::cout << "read file failed" << std::endl;
		return -1;
	}
	size_t size = ret;

	std::string ds;

	if (strncmp(argv[1], "-c", strlen("-c")) == 0)
		snappy::Compress(buf, size, &ds);
	else
		snappy::Uncompress(buf, size, &ds);

	std::cout<<"in size:" <<size<<" out size:"<<ds.size()<<std::endl;

	free(buf);

	write_file(argv[3], ds.data(), ds.size());

	return 0;
}
