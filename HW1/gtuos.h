#ifndef H_GTUOS
#define H_GTUOS

#include <fstream>
#include "8080emuCPP.h"


class GTUOS{
	public:
		uint64_t handleCall(const CPU8080 & cpu, std::ofstream & outputfile);
};

#endif
