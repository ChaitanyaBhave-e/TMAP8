l=10
nx=100
num_steps=10

[Mesh]
  type = GeneratedMesh
  dim = 1
  xmax = ${l}
  nx = ${nx}
  elem_type = EDGE3
[]

[Variables]
  [u]
    order = SECOND
  []
  [lm]
  []
[]

[ICs]
  [u]
    type = FunctionIC
    variable = u
    function = '${l} - x'
  []
[]

[Kernels]
  [time]
    type = TimeDerivative
    variable = u
  []
  [diff]
    type = Diffusion
    variable = u
  []
  [ffn]
    type = BodyForce
    variable = u
    function = '-1'
  []
  [lm_coupled_force]
    type = CoupledForce
    variable = u
    v = lm
  []
  [positive_constraint]
    type = RequirePositiveNCP
    variable = lm
    v = u
  []
[]

[BCs]
  [left]
    type = DirichletBC
    boundary = left
    value = ${l}
    variable = u
  []
  [right]
    type = DirichletBC
    boundary = right
    value = 0
    variable = u
  []
[]

[NodalKernels]
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  num_steps = ${num_steps}
  solve_type = NEWTON
  petsc_options_iname = '-snes_max_linear_solve_fail -ksp_max_it -pc_factor_levels'
  petsc_options_value = '0                           30          16'
[]

[Outputs]
  exodus = true
[]

[Debug]
  show_var_residual_norms = true
[]

[Postprocessors]
  [active_lm]
    type = GreaterThanLessThanPostprocessor
    variable = lm
    execute_on = 'nonlinear timestep_end'
    value = 1e-12
  []
  [violations]
    type = GreaterThanLessThanPostprocessor
    variable = u
    execute_on = 'nonlinear timestep_end'
    value = -1e-12
    comparator = 'less'
  []
[]
