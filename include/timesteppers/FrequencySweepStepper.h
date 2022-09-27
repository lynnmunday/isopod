//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "TimeStepper.h"

class FrequencySweepStepper : public TimeStepper
{
public:
  static InputParameters validParams();

  FrequencySweepStepper(const InputParameters & parameters);

protected:
  virtual Real computeDT() override;
  virtual Real computeInitialDT() override;
  virtual Real computeFailedDT() override;

private:
  const Real _freq_step_size;
};
