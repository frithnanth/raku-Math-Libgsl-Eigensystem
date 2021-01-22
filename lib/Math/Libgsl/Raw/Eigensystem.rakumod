use v6;

unit module Math::Libgsl::Raw::Eigensystem:ver<0.0.1>:auth<cpan:FRITH>;

use NativeCall;
use Math::Libgsl::Raw::Matrix;
use Math::Libgsl::Raw::Matrix::Complex64;

sub LIB {
  run('/sbin/ldconfig', '-p', :chomp, :out)
    .out
    .slurp(:close)
    .split("\n")
    .grep(/^ \s+ libgsl\.so\. \d+ /)
    .sort
    .head
    .comb(/\S+/)
    .head;
}

class gsl_eigen_symm_workspace is repr('CStruct') is export {
  has size_t         $.size;
  has Pointer[num64] $.d;
  has Pointer[num64] $.sd;
}

class gsl_eigen_symmv_workspace is repr('CStruct') is export {
  has size_t         $.size;
  has Pointer[num64] $.d;
  has Pointer[num64] $.sd;
  has Pointer[num64] $.gc;
  has Pointer[num64] $.gs;
}

class gsl_eigen_herm_workspace is repr('CStruct') is export {
  has size_t         $.size;
  has Pointer[num64] $.d;
  has Pointer[num64] $.sd;
  has Pointer[num64] $.tau;
}

class gsl_eigen_hermv_workspace is repr('CStruct') is export {
  has size_t         $.size;
  has Pointer[num64] $.d;
  has Pointer[num64] $.sd;
  has Pointer[num64] $.tau;
  has Pointer[num64] $.gc;
  has Pointer[num64] $.gs;
}

class gsl_eigen_francis_workspace is repr('CStruct') is export {
  has size_t         $.size;
  has size_t         $.max_iterations;
  has size_t         $.n_iter;
  has size_t         $.n_evals;
  has int32          $.compute_t;
  has gsl_matrix     $.H;
  has gsl_matrix     $.Z;
}

class gsl_eigen_nonsymm_workspace is repr('CStruct') is export {
  has size_t         $.size;
  has gsl_vector     $.diag;
  has gsl_vector     $.tau;
  has gsl_matrix     $.Z;
  has int32          $.do_balance;
  has size_t         $.n_evals;
  has gsl_eigen_francis_workspace $.francis_workspace_p;
}

class gsl_eigen_nonsymmv_workspace is repr('CStruct') is export {
  has size_t         $.size;
  has gsl_vector     $.work;
  has gsl_vector     $.work2;
  has gsl_vector     $.work3;
  has gsl_matrix     $.Z;
  has gsl_eigen_francis_workspace $.francis_workspace_p;
}

class gsl_eigen_gensymm_workspace is repr('CStruct') is export {
  has size_t         $.size;
  has gsl_eigen_symm_workspace $.symm_workspace_p;
}

class gsl_eigen_gensymmv_workspace is repr('CStruct') is export {
  has size_t         $.size;
  has gsl_eigen_symmv_workspace $.symmv_workspace_p;
}

class gsl_eigen_genherm_workspace is repr('CStruct') is export {
  has size_t         $.size;
  has gsl_eigen_herm_workspace $.herm_workspace_p;
}

class gsl_eigen_genhermv_workspace is repr('CStruct') is export {
  has size_t         $.size;
  has gsl_eigen_hermv_workspace $.hermv_workspace_p;
}

class gsl_eigen_gen_workspace is repr('CStruct') is export {
  has size_t         $.size;
  has gsl_vector     $.work;
  has size_t         $.n_evals;
  has size_t         $.max_iterations;
  has size_t         $.n_iter;
  has num64          $.eshift;
  has int32          $.needtop;
  has num64          $.atol;
  has num64          $.btol;
  has num64          $.ascale;
  has num64          $.bscale;
  has gsl_matrix     $.H;
  has gsl_matrix     $.R;
  has int32          $.compute_s;
  has int32          $.compute_t;
  has gsl_matrix     $.Q;
  has gsl_matrix     $.Z;
}

class gsl_eigen_genv_workspace is repr('CStruct') is export {
  has size_t         $.size;
  has gsl_vector     $.work1;
  has gsl_vector     $.work2;
  has gsl_vector     $.work3;
  has gsl_vector     $.work4;
  has gsl_vector     $.work5;
  has gsl_vector     $.work6;
  has gsl_matrix     $.Q;
  has gsl_matrix     $.Z;
  has gsl_eigen_gen_workspace $.gen_workspace_p;
}

# Real Symmetric Matrices
sub gsl_eigen_symm_alloc(size_t $n --> gsl_eigen_symm_workspace) is native(LIB) is export { * }
sub gsl_eigen_symm_free(gsl_eigen_symm_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_symm(gsl_matrix $A, gsl_vector $eval, gsl_eigen_symm_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_eigen_symmv_alloc(size_t $n --> gsl_eigen_symmv_workspace) is native(LIB) is export { * }
sub gsl_eigen_symmv_free(gsl_eigen_symmv_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_symmv(gsl_matrix $A, gsl_vector $eval, gsl_matrix $evec, gsl_eigen_symmv_workspace $w --> int32) is native(LIB) is export { * }
# Complex Hermitian Matrices
sub gsl_eigen_herm_alloc(size_t $n --> gsl_eigen_herm_workspace) is native(LIB) is export { * }
sub gsl_eigen_herm_free(gsl_eigen_herm_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_herm(gsl_matrix_complex $A, gsl_vector $eval, gsl_eigen_herm_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_eigen_hermv_alloc(size_t $n --> gsl_eigen_hermv_workspace) is native(LIB) is export { * }
sub gsl_eigen_hermv_free(gsl_eigen_hermv_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_hermv(gsl_matrix_complex $A, gsl_vector $eval, gsl_matrix_complex $evec, gsl_eigen_hermv_workspace $w --> int32) is native(LIB) is export { * }
# Real Non-Symmetric Matrices
sub gsl_eigen_nonsymm_alloc(size_t $n --> gsl_eigen_nonsymm_workspace) is native(LIB) is export { * }
sub gsl_eigen_nonsymm_free(gsl_eigen_nonsymm_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_nonsymm_params(int32 $compute_t, int32 $balance, gsl_eigen_nonsymm_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_nonsymm(gsl_matrix $A, gsl_vector_complex $eval, gsl_eigen_nonsymm_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_eigen_nonsymm_Z(gsl_matrix $A, gsl_vector_complex $eval, gsl_matrix $Z, gsl_eigen_nonsymm_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_eigen_nonsymmv_alloc(size_t $n --> gsl_eigen_nonsymmv_workspace) is native(LIB) is export { * }
sub gsl_eigen_nonsymmv_free(gsl_eigen_nonsymmv_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_nonsymmv_params(int32 $balance, gsl_eigen_nonsymmv_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_nonsymmv(gsl_matrix $A, gsl_vector_complex $eval, gsl_matrix_complex $evec, gsl_eigen_nonsymmv_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_eigen_nonsymmv_Z(gsl_matrix $A, gsl_vector_complex $eval, gsl_matrix_complex $evec, gsl_matrix $Z, gsl_eigen_nonsymmv_workspace $w --> int32) is native(LIB) is export { * }
# Real Generalized Symmetric-Definite Eigensystems
sub gsl_eigen_gensymm_alloc(size_t $n --> gsl_eigen_gensymm_workspace) is native(LIB) is export { * }
sub gsl_eigen_gensymm_free(gsl_eigen_gensymm_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_gensymm(gsl_matrix $A, gsl_matrix $B, gsl_vector $eval, gsl_eigen_gensymm_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_eigen_gensymmv_alloc(size_t $n --> gsl_eigen_gensymmv_workspace) is native(LIB) is export { * }
sub gsl_eigen_gensymmv_free(gsl_eigen_gensymmv_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_gensymmv(gsl_matrix $A, gsl_matrix $B, gsl_vector $eval, gsl_matrix $evec, gsl_eigen_gensymmv_workspace $w --> int32) is native(LIB) is export { * }
# Complex Generalized Hermitian-Definite Eigensystems
sub gsl_eigen_genherm_alloc(size_t $n --> gsl_eigen_genherm_workspace) is native(LIB) is export { * }
sub gsl_eigen_genherm_free(gsl_eigen_genherm_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_genherm(gsl_matrix_complex $A, gsl_matrix_complex $B, gsl_vector $eval, gsl_eigen_genherm_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_eigen_genhermv_alloc(size_t $n --> gsl_eigen_genhermv_workspace) is native(LIB) is export { * }
sub gsl_eigen_genhermv_free(gsl_eigen_genhermv_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_genhermv(gsl_matrix_complex $A, gsl_matrix_complex $B, gsl_vector $eval, gsl_matrix_complex $evec, gsl_eigen_genhermv_workspace $w --> int32) is native(LIB) is export { * }
# Real Generalized Nonsymmetric Eigensystems
sub gsl_eigen_gen_alloc(size_t $n --> gsl_eigen_gen_workspace) is native(LIB) is export { * }
sub gsl_eigen_gen_free(gsl_eigen_gen_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_gen_params(int32 $compute_s, int32 $compute_t, int32 $balance, gsl_eigen_gen_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_gen(gsl_matrix $A, gsl_matrix $B, gsl_vector_complex $alpha, gsl_vector $beta, gsl_eigen_gen_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_eigen_gen_QZ(gsl_matrix $A, gsl_matrix $B, gsl_vector_complex $alpha, gsl_vector $beta, gsl_matrix $Q, gsl_matrix $Z, gsl_eigen_gen_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_eigen_genv_alloc(size_t $n --> gsl_eigen_genv_workspace) is native(LIB) is export { * }
sub gsl_eigen_genv_free(gsl_eigen_genv_workspace $w) is native(LIB) is export { * }
sub gsl_eigen_genv(gsl_matrix $A, gsl_matrix $B, gsl_vector_complex $alpha, gsl_vector $beta, gsl_matrix $evec, gsl_eigen_genv_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_eigen_genv_QZ(gsl_matrix $A, gsl_matrix $B, gsl_vector_complex $alpha, gsl_vector $beta, gsl_matrix $evec, gsl_matrix $Q, gsl_matrix $Z, gsl_eigen_genv_workspace $w --> int32) is native(LIB) is export { * }
# Sorting Eigenvalues and Eigenvectors
sub gsl_eigen_symmv_sort(gsl_vector $eval, gsl_matrix $evec, int32 $sort_type --> int32) is native(LIB) is export { * }
sub gsl_eigen_hermv_sort(gsl_vector $eval, gsl_matrix_complex $evec, int32 $sort_type --> int32) is native(LIB) is export { * }
sub gsl_eigen_nonsymmv_sort(gsl_vector_complex $eval, gsl_matrix_complex $evec, int32 $sort_type --> int32) is native(LIB) is export { * }
sub gsl_eigen_gensymmv_sort(gsl_vector $eval, gsl_matrix $evec, int32 $sort_type --> int32) is native(LIB) is export { * }
sub gsl_eigen_genhermv_sort(gsl_vector $eval, gsl_matrix_complex $evec, int32 $sort_type --> int32) is native(LIB) is export { * }
sub gsl_eigen_genv_sort(gsl_vector_complex $alpha, gsl_vector $beta, gsl_matrix_complex $evec, int32 $sort_type --> int32) is native(LIB) is export { * }
