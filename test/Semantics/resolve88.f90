! RUN: %B/test/Semantics/test_errors.sh %s %flang %t
! C746, C747, and C748
module m
  use ISO_FORTRAN_ENV
  use ISO_C_BINDING

  ! C746 If a coarray-spec appears, it shall be a deferred-coshape-spec-list and
  ! the component shall have the ALLOCATABLE attribute.

  type testCoArrayType
    real, allocatable, codimension[:] :: allocatableField
    !ERROR: Coarray components must be ALLOCATABLE and have a deferred coshape
    real, codimension[:] :: deferredField
    !ERROR: 'pointerfield' may not have the POINTER attribute because it is a coarray
    !ERROR: Coarray components must be ALLOCATABLE and have a deferred coshape
    real, pointer, codimension[:] :: pointerField
    !ERROR: Coarray components must be ALLOCATABLE and have a deferred coshape
    real, codimension[*] :: realField
  end type testCoArrayType

  ! C747 If a coarray-spec appears, the component shall not be of type C_PTR or
  ! C_FUNPTR from the intrinsic module ISO_C_BINDING (18.2), or of type 
  ! TEAM_TYPE from the intrinsic module ISO_FORTRAN_ENV (16.10.2).

  type goodCoarrayType
    real, allocatable, codimension[:] :: field
  end type goodCoarrayType

  type goodTeam_typeCoarrayType
    type(team_type), allocatable :: field
  end type goodTeam_typeCoarrayType

  type goodC_ptrCoarrayType
    type(c_ptr), allocatable :: field
  end type goodC_ptrCoarrayType

  type goodC_funptrCoarrayType
    type(c_funptr), allocatable :: field
  end type goodC_funptrCoarrayType

  type team_typeCoarrayType
    !ERROR: A coarray component may not be of type TEAM_TYPE from ISO_FORTRAN_ENV
    type(team_type), allocatable, codimension[:] :: field
  end type team_typeCoarrayType

  type c_ptrCoarrayType
    !ERROR: A coarray component may not be of C_PTR or C_FUNPTR from ISO_C_BINDING when an allocatable object is a coarray
    type(c_ptr), allocatable, codimension[:] :: field
  end type c_ptrCoarrayType

  type c_funptrCoarrayType
    !ERROR: A coarray component may not be of C_PTR or C_FUNPTR from ISO_C_BINDING when an allocatable object is a coarray
    type(c_funptr), allocatable, codimension[:] :: field
  end type c_funptrCoarrayType

! C748 A data component whose type has a coarray ultimate component shall be a
! nonpointer nonallocatable scalar and shall not be a coarray.

  type coarrayType
    real, allocatable, codimension[:] :: goodCoarrayField
  end type coarrayType

  type testType
    type(coarrayType) :: goodField
    !ERROR: A component whose type has a coarray ultimate component cannot be a POINTER or ALLOCATABLE
    type(coarrayType), pointer :: pointerField
    !ERROR: A component whose type has a coarray ultimate component cannot be a POINTER or ALLOCATABLE
    type(coarrayType), allocatable :: allocatableField
    !ERROR: A component whose type has a coarray ultimate component cannot be an array or corray
    type(coarrayType), dimension(3) :: arrayField
  end type testType

end module m
