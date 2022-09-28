#w=10
[Mesh]
   type = GeneratedMesh
   dim = 3
   xmin=0
   xmax=1
   nx=30
   ymin=0
   ymax=0.1
   ny = 3
   zmin=0
   zmax=0.1
   nz = 3
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Problem]
 type = ReferenceResidualProblem
 reference_vector = 'ref'
 extra_tag_vectors = 'ref'
 group_variables = 'disp_x disp_y disp_z'
[]

[Modules]
  [TensorMechanics]
    [Master]
      [all]
        strain = SMALL
        add_variables = true
        new_system = true
        formulation = TOTAL
        volumetric_locking_correction = true
        generate_output = 'cauchy_stress_xx cauchy_stress_yy cauchy_stress_zz '
                          'cauchy_stress_xy cauchy_stress_xz cauchy_stress_yz '
                          'strain_xx strain_yy strain_zz strain_xy strain_xz strain_yz'
      []
    []
  []
[]

[Kernels]
    #reaction terms
    [reaction_realx]
        type = Reaction
        variable = disp_x
        rate = 1#${fparse -w*w}
        extra_vector_tags = 'ref'
    []
    [reaction_realy]
        type = Reaction
        variable = disp_y
        rate = 1#${fparse -w*w}
        extra_vector_tags = 'ref'
    []
    [reaction_realz]
        type = Reaction
        variable = disp_z
        rate = 1#${fparse -w*w}
        extra_vector_tags = 'ref'
    []
[]

[BCs]
#Left
[disp_x_left]
  type = DirichletBC
  variable = disp_x
  boundary = 'left'
  value = 0.0
[]
[disp_y_left]
  type = DirichletBC
  variable = disp_y
  boundary = 'left'
  value = 0.0
[]
[disp_z_left]
  type = DirichletBC
  variable = disp_z
  boundary = 'left'
  value = 0.0
[]
#Right
[BC_right_yreal]
    type = NeumannBC
    variable = disp_y
    boundary = 'right'
    value = 100
[]
[]

[Materials]
  [elastic_tensor_Al]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 68e9
    poissons_ratio = 0.36
  []
  [compute_stress]
    type = ComputeLagrangianLinearElasticStress
  []
[]

[Postprocessors]
  [midpt_real]
    type = PointValue
    point = '0.5 0.05 0.05'
    variable = disp_y
  []
[]

[Functions]
  [./freq2]
    type = ParsedFunction
    vars = density
    vals = 2.7e3 #Al kg/m3
    value = '-t*t*density'
  [../]
[]

[Controls]
  [./func_control]
    type = RealFunctionControl
    parameter = 'Kernels/*/rate'
    function = 'freq2'
    execute_on = 'initial timestep_begin'
  [../]
[]

[Executioner]
  type = Transient
  solve_type=NEWTON
  petsc_options_iname = ' -pc_type'
  petsc_options_value = 'lu'
  start_time = 490  #starting frequency
  end_time =  520  #ending frequency
  nl_abs_tol = 1e-6
  [TimeStepper]
    type = FrequencySweepStepper
    freqStepSize = 5
  []
[]

[Outputs]
    # csv=true
    exodus=true
[]
