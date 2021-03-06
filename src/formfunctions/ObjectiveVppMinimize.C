#include "ObjectiveVppMinimize.h"

registerMooseObject("isopodApp", ObjectiveVppMinimize);

InputParameters
ObjectiveVppMinimize::validParams()
{
  InputParameters params = FormFunction::validParams();
  params.addRequiredParam<VectorPostprocessorName>("data_vpp",
                                                   "VectorPostprocessorReceiver for data results.");
  return params;
}

ObjectiveVppMinimize::ObjectiveVppMinimize(const InputParameters & parameters)
  : FormFunction(parameters),
    _simulation_values(getVectorPostprocessorValue(
        "data_vpp", "temperature", false)), // fixme lynn temperature should not be hardcoded
    _measured_values(getVectorPostprocessorValue("data_vpp", "measured_data", false))
{
}

Real
ObjectiveVppMinimize::computeObjective()
{
  Real val = 0;
  for (std::size_t i = 0; i < _simulation_values.size(); ++i)
  {
    Real tmp = _simulation_values[i] - _measured_values[i];
    val += tmp * tmp;
  }

  return val;
}
