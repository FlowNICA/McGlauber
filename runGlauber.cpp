#include <iostream>
#include<string>

#include <TROOT.h>
#include <TStopwatch.h>
#include <Math/SpecFuncMathMore.h>
#include <TRandom.h>
#include <TRandom3.h>

#include "runglauber_v3.2.C"

int main(int argc, char **argv)
{
  Int_t Nev;
  TString TargName, ProjName, outName;
  Double_t cross, crossWidth, mind, omega, noded;
  int seed;

  mind = 0.4;
  omega = -1;
  noded = -1;
  crossWidth = -1;

  TStopwatch timer;
  if (argc < 11)
  {
    std::cerr << "./runGlauber -nev Nev -targ TARGET -proj PROJECTILE -sigmNN CROSS_SECTION -seed SEED -o OUTPUTFILE" << std::endl;
    return 10;
  }
  for (int i=1;i<argc;i++)
  {
    if (std::string(argv[i]) != "-nev" &&
        std::string(argv[i]) != "-o" &&
        std::string(argv[i]) != "-targ" &&
        std::string(argv[i]) != "-proj" &&
        std::string(argv[i]) != "-sigmNN" &&
        std::string(argv[i]) != "-seed")
    {
      std::cerr << "\nUnknown parameter: " << argv[i] << std::endl;
      return 11;
    }
    else
    {
      if (std::string(argv[i]) == "-o" && i != argc-1)
      {
        outName = TString(argv[++i]);
      }
      if (std::string(argv[i]) == "-o" && i == argc-1)
      {
        std::cerr << "\nOutput file is not defined!" << std::endl;
        return 12;
      }
      if (std::string(argv[i]) == "-targ" && i != argc-1)
      {
        TargName = TString(argv[++i]);
      }
      if (std::string(argv[i]) == "-targ" && i == argc-1)
      {
        std::cerr << "\nTarget name is not defined!" << std::endl;
        return 13;
      }
      if (std::string(argv[i]) == "-proj" && i != argc-1)
      {
        ProjName = TString(argv[++i]);
      }
      if (std::string(argv[i]) == "-proj" && i == argc-1)
      {
        std::cerr << "\nProjectile name is not defined!" << std::endl;
        return 14;
      }
      if (std::string(argv[i]) == "-nev" && i != argc-1)
      {
        Nev = std::stoi(std::string(argv[++i]));
      }
      if (std::string(argv[i]) == "-nev" && i == argc-1)
      {
        std::cerr << "\nNumber of events is not defined!" << std::endl;
        return 15;
      }
      if (std::string(argv[i]) == "-sigmNN" && i != argc-1)
      {
        cross = std::stod(std::string(argv[++i]));
      }
      if (std::string(argv[i]) == "-sigmNN" && i == argc-1)
      {
        std::cerr << "\nCross section is not defined!" << std::endl;
        return 16;
      }
      if (std::string(argv[i]) == "-seed" && i != argc-1)
      {
        seed = std::stoi(std::string(argv[++i]));
        if (seed <=0)
        {
          std::cerr << "\nWARNING: wrong value for seed! Set to default." << std::endl;
        }
      }
      if (std::string(argv[i]) == "-seed" && i == argc-1)
      {
        std::cerr << "\nSeed is not defined!" << std::endl;
        return 17;
      }
    }
  }
  if (outName == "" || TargName == "" || ProjName == "")
  {
    std::cerr << "\nOutput/Target/Projectile has not been set properly!" << std::endl;
    return 17;
  }

  gRandom->SetSeed(seed);

  timer.Start();
  runAndSaveNtuple(Nev,TargName.Data(),ProjName.Data(),cross,crossWidth,mind,omega,noded,outName.Data());
  timer.Stop();
  timer.Print();

  return 0;
}
