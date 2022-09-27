//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "FrequencySweepStepper.h"

registerMooseObject("isopodApp", FrequencySweepStepper);
InputParameters
FrequencySweepStepper::validParams()
{
  InputParameters params = TimeStepper::validParams();
  params.addRequiredParam<Real>("freqStepSize", "Size of each frequency step");
  params.addClassDescription("Timestepper that takes a constant time step and skips over failed "
                             "solves without cutting timestep");
  return params;
}

FrequencySweepStepper::FrequencySweepStepper(const InputParameters & parameters)
  : TimeStepper(parameters), _freq_step_size(getParam<Real>("freqStepSize"))
{
}

Real
FrequencySweepStepper::computeInitialDT()
{
  return _freq_step_size;
}

Real
FrequencySweepStepper::computeDT()
{
  return _freq_step_size;
}

Real
FrequencySweepStepper::computeFailedDT()
{
  return _dt + _freq_step_size;
}
