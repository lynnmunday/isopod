w=10 #frequency
[Mesh]
   type = GeneratedMesh
   dim = 1
   xmin=0
   xmax=1
   nx = 1000
[]

[Variables]
    [uxr]
       order = FIRST
       family = LAGRANGE
    []
    [uxi]
       order = FIRST
       family = LAGRANGE
    []
[]

[Kernels]
  #stressdivergence terms
    [urealx]
        type = StressDivergenceTensors
        variable = uxr
        displacements='uxr'
        component = 0
        base_name = real
    []
    [uimagx]
        type = StressDivergenceTensors
        variable = uxi
        displacements='uxi'
        component = 0
        base_name = imag
    []
    #reaction terms
    [reaction_realx]
        type = MatReaction
        variable = uxr
        mob_name = omega_sq
    []
    [reaction_imagx]
        type = MatReaction
        variable = uxi
        mob_name = omega_sq
    []
[]

[BCs]
#Left
#[uxr_left]
#      type = CoupledVarNeumannBC
#      variable = uxr
#      boundary = 'left'
#      v = uxi
#      coef=${fparse -w}
#[]
#[uxi_left]
#      type = CoupledVarNeumannBC
#      variable = uxi
#      boundary = 'left'
#      v = uxr
#      coef=${fparse w}
#[]
  #Right
  [BC_right_xreal]
        type = DirichletBC
        variable = uxr
        boundary = 'right'
        value = 0.5
  []
  [BC_right_ximag]
        type = DirichletBC
        variable = uxi
        boundary = 'right'
        value = 0
  []
[]

[Materials]
  [omega_sq]
    type = ParsedMaterial
    f_name = omega_sq
    function = 't*t'
    outputs = exodus
  []

  [elasticity_tensor_real]
    type = ComputeIsotropicElasticityTensor
    base_name = real
    youngs_modulus = 1
    poissons_ratio = 0.0
  []
  [strain_real]
    type = ComputeSmallStrain
    base_name = real
    displacements='uxr'
  []
  [stress_real]
    type = ComputeLinearElasticStress
    base_name = real
  []

   [elasticity_tensor_imag]
    type = ComputeIsotropicElasticityTensor
    base_name = imag
    youngs_modulus = 1
    poissons_ratio = 0.0
  []
  [strain_imag]
    type = ComputeSmallStrain
    base_name = imag
    displacements='uxi'
  []
  [stress_imag]
    type = ComputeLinearElasticStress
    base_name = imag
  []

[]
[VectorPostprocessors]
  [midpt_real]
    type = PointValueSampler
    variable = uxr
    points = '0.5 0.0 0'
    sort_by = id
  []
  [midpt_imag]
    type = PointValueSampler
    variable = uxi
    points = '0.5 0.0 0'
    sort_by = id
    []
[]
[Outputs]
    csv=true
    exodus=false
    [exodus]
      type=Exodus
    []
[]

[Executioner]
  type = Transient
  solve_type=NEWTON
  petsc_options_iname = ' -pc_type'
  petsc_options_value = 'lu'
  start_time = 5
  end_time =  100
  [TimeStepper]
    type = ConstantDT
    freqStepSize = 5
    dt=0
  []
[]
