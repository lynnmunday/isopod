[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 20
  xmax = 2
  ymax = 2
[]


[StochasticTools]
[]

[FormFunction]
  type = ObjectiveGradientMinimize
  adjoint_vpp = 'adjoint_results'
  adjoint_data_computed = 'adjoint_rec_0'
  parameter_vpp = 'parameter_results'
  data_computed = 'data_rec_0 data_rec_1 data_rec_2 data_rec_3'
  data_target = '226 254 214 146'
[]

[Executioner]
  type = Optimize
  tao_solver = taolmvm #TAOOWLQN #TAOBMRM #taolmvm #taocg
  petsc_options_iname = '-tao_gatol'# -tao_cg_delta_max'
  petsc_options_value = '1e-4'

  # petsc_options_iname='-tao_fd_test -tao_test_gradient -tao_fd_gradient -tao_fd_delta -tao_gatol'
  # petsc_options_value='true true false 0.0001 0.0001'

  verbose = true
[]

[MultiApps]
  [forward]
    type = OptimizeFullSolveMultiApp
    input_files = forward.i
    execute_on = "FORWARD"
  []
  [adjoint]
    type = OptimizeFullSolveMultiApp
    input_files = adjoint.i
    execute_on = "ADJOINT"
  []
[]

[AuxVariables]
  [temperature_forward]
  []
[]

[Transfers]
  [toforward]
    type = OptimizationParameterTransfer
    multi_app = forward
    parameter_vpp = parameter_results
    to_control = parameterReceiver
  []
  [pp_transfer_0]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    multi_app = forward
    from_postprocessor = data_pt_0
    to_postprocessor = data_rec_0
    reduction_type = average
  []
  [pp_transfer_1]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    multi_app = forward
    from_postprocessor = data_pt_1
    to_postprocessor = data_rec_1
    reduction_type = average
  []
  [pp_transfer_2]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    multi_app = forward
    from_postprocessor = data_pt_2
    to_postprocessor = data_rec_2
    reduction_type = average
  []
  [pp_transfer_3]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    multi_app = forward
    from_postprocessor = data_pt_3
    to_postprocessor = data_rec_3
    reduction_type = average
  []
  [toAdjoint]
    type = OptimizationParameterTransfer
    multi_app = adjoint
    parameter_vpp = adjoint_results
    to_control = adjointReceiver
  []
  [pp_adjoint_0]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    multi_app = adjoint
    from_postprocessor = adjoint_pt_0
    to_postprocessor = adjoint_rec_0
    reduction_type = average
  []
  [toAdjoint2]
    type = OptimizationParameterTransfer
    multi_app = adjoint
    parameter_vpp = parameter_results
    to_control = adjointReceiver2
  []
  # get forward problem solution
  [fromforward]
    type = MultiAppCopyTransfer
    multi_app = forward
    direction = from_multiapp
    source_variable = 'temperature'
    variable = 'temperature_forward'
    execute_on = 'initial linear'
  []
  # transfer variable to adjiont
  [toAdjoint3]
    type = MultiAppCopyTransfer
    multi_app = adjoint
    direction = to_multiapp
    source_variable = 'temperature_forward'
    variable = 'temperature_forward'
    execute_on = 'initial linear'
  []
[]

[VectorPostprocessors]
  [parameter_results]
    type = OptimizationParameterVectorPostprocessor
    parameters = 'Postprocessors/p1/value'
  []
  [adjoint_results]
    type = OptimizationParameterVectorPostprocessor
    parameters = 'DiracKernels/pt0/value
                  DiracKernels/pt1/value
                  DiracKernels/pt2/value
                  DiracKernels/pt3/value'
  []
[]

[Postprocessors]
  [data_rec_0]
    type = Receiver
  []
  [data_rec_1]
    type = Receiver
  []
  [data_rec_2]
    type = Receiver
  []
  [data_rec_3]
    type = Receiver
  []

  [adjoint_rec_0]
    type = Receiver
    outputs = none
  []
[]


[Outputs]
  console = true
  csv=true
[]