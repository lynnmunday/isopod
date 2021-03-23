#pragma once

#include "Steady.h"
#include "OptimizeSolve.h"

// System includes
#include <string>

// Forward declarations
class InputParameters;
class Optimize;
class FEProblemBase;

class Optimize : public Steady
{
public:
  static InputParameters validParams();

  Optimize(const InputParameters & parameters);

  virtual void execute() override;

  OptimizeSolve & getOptimizeSolve() { return _optim_solve; }

protected:
  OptimizeSolve _optim_solve;
};
