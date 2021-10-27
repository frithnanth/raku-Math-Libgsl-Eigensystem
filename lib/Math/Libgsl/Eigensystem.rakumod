unit class Math::Libgsl::Eigensystem:ver<0.0.2>:auth<cpan:FRITH>;

use NativeCall;
use Math::Libgsl::Constants;
use Math::Libgsl::Exception;
use Math::Libgsl::Vector;
use Math::Libgsl::Matrix;
use Math::Libgsl::Vector::Complex64;
use Math::Libgsl::Matrix::Complex64;
use Math::Libgsl::Raw::Eigensystem;

class RealSymm {
  has gsl_eigen_symm_workspace  $.ws;
  has gsl_eigen_symmv_workspace $.wsv;
  has Bool                      $.vectors;

  multi method new(Int $size!, Bool $vectors! where .so)     { self.bless(:$size, :vectors)  }
  multi method new(Int $size!, Bool $vectors! where ! .so)   { self.bless(:$size, :!vectors) }
  multi method new(Int $size!)                               { self.bless(:$size, :!vectors) }
  multi method new(Int :$size!, Bool :$vectors! where .so)   { self.bless(:$size, :vectors)  }
  multi method new(Int :$size!, Bool :$vectors! where ! .so) { self.bless(:$size, :!vectors) }
  multi method new(Int :$size!)                              { self.bless(:$size, :!vectors) }

  submethod BUILD(Int :$size!, Bool :$!vectors) {
    if $!vectors {
      $!wsv = gsl_eigen_symmv_alloc($size);
    } else {
      $!ws = gsl_eigen_symm_alloc($size);
    }
  }
  submethod DESTROY {
    if $!vectors {
      gsl_eigen_symmv_free($!wsv);
    } else {
      gsl_eigen_symm_free($!ws);
    }
  }
  method compute(
      Math::Libgsl::Matrix $A where .matrix.size1 == .matrix.size2,
      gsl_eigen_sort_t :$sort
      --> List) {
    fail X::Libgsl.new: errno => GSL_FAILURE, error => "The matrix has the wrong size"
        if $A.matrix.size1 != ($!vectors ?? $!wsv.size !! $!ws.size);

    my @output;
    my Math::Libgsl::Vector $eval .= new: $A.matrix.size1;
    my Math::Libgsl::Matrix $evec;

    if $!vectors {
      $evec .= new: $A.matrix.size1, $A.matrix.size2;
      my $ret = gsl_eigen_symmv($A.matrix, $eval.vector, $evec.matrix, $!wsv);
      fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues and eigenvectors" if $ret ≠ GSL_SUCCESS;
      @output := $eval, $evec;
      with $sort {
        $ret = gsl_eigen_symmv_sort($eval.vector, $evec.matrix, $sort);
        fail X::Libgsl.new: errno => $ret, error => "Can't sort eigenvalues and eigenvectors" if $ret ≠ GSL_SUCCESS;
      }
    } else {
      my $ret = gsl_eigen_symm($A.matrix, $eval.vector, $!ws);
      fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues" if $ret ≠ GSL_SUCCESS;
      @output[0] := $eval;
    }

    return @output;
  }
}

class ComplexHerm {
  has gsl_eigen_herm_workspace  $.ws;
  has gsl_eigen_hermv_workspace $.wsv;
  has Bool                      $.vectors;

  multi method new(Int $size!, Bool $vectors! where .so)     { self.bless(:$size, :vectors)  }
  multi method new(Int $size!, Bool $vectors! where ! .so)   { self.bless(:$size, :!vectors) }
  multi method new(Int $size!)                               { self.bless(:$size, :!vectors) }
  multi method new(Int :$size!, Bool :$vectors! where .so)   { self.bless(:$size, :vectors)  }
  multi method new(Int :$size!, Bool :$vectors! where ! .so) { self.bless(:$size, :!vectors) }
  multi method new(Int :$size!)                              { self.bless(:$size, :!vectors) }

  submethod BUILD(Int :$size!, Bool :$!vectors) {
    if $!vectors {
      $!wsv = gsl_eigen_hermv_alloc($size);
    } else {
      $!ws = gsl_eigen_herm_alloc($size);
    }
  }
  submethod DESTROY {
    if $!vectors {
      gsl_eigen_hermv_free($!wsv);
    } else {
      gsl_eigen_herm_free($!ws);
    }
  }
  method compute(
      Math::Libgsl::Matrix::Complex64 $A where .matrix.size1 == .matrix.size2,
      gsl_eigen_sort_t :$sort
      --> List) {
    fail X::Libgsl.new: errno => GSL_FAILURE, error => "The matrix has the wrong size"
        if $A.matrix.size1 != ($!vectors ?? $!wsv.size !! $!ws.size);

    my @output;
    my Math::Libgsl::Vector $eval .= new: $A.matrix.size1;
    my Math::Libgsl::Matrix::Complex64 $evec;

    if $!vectors {
      $evec .= new: $A.matrix.size1, $A.matrix.size2;
      my $ret = gsl_eigen_hermv($A.matrix, $eval.vector, $evec.matrix, $!wsv);
      fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues and eigenvectors" if $ret ≠ GSL_SUCCESS;
      @output := $eval, $evec;
      with $sort {
        $ret = gsl_eigen_hermv_sort($eval.vector, $evec.matrix, $sort);
        fail X::Libgsl.new: errno => $ret, error => "Can't sort eigenvalues and eigenvectors" if $ret ≠ GSL_SUCCESS;
      }
    } else {
      my $ret = gsl_eigen_herm($A.matrix, $eval.vector, $!ws);
      fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues" if $ret ≠ GSL_SUCCESS;
      @output[0] := $eval;
    }

    return @output;
  }
}

class RealNonSymm {
  has gsl_eigen_nonsymm_workspace  $.ws;
  has gsl_eigen_nonsymmv_workspace $.wsv;
  has Bool                         $.vectors;

  multi method new(Int $size!, Bool $vectors! where .so)     { self.bless(:$size, :vectors)  }
  multi method new(Int $size!, Bool $vectors! where ! .so)   { self.bless(:$size, :!vectors) }
  multi method new(Int $size!)                               { self.bless(:$size, :!vectors) }
  multi method new(Int :$size!, Bool :$vectors! where .so)   { self.bless(:$size, :vectors)  }
  multi method new(Int :$size!, Bool :$vectors! where ! .so) { self.bless(:$size, :!vectors) }
  multi method new(Int :$size!)                              { self.bless(:$size, :!vectors) }

  submethod BUILD(Int :$size!, Bool :$!vectors) {
    if $!vectors {
      $!wsv = gsl_eigen_nonsymmv_alloc($size);
    } else {
      $!ws = gsl_eigen_nonsymm_alloc($size);
    }
  }
  submethod DESTROY {
    if $!vectors {
      gsl_eigen_nonsymmv_free($!wsv);
    } else {
      gsl_eigen_nonsymm_free($!ws);
    }
  }
  method compute(Math::Libgsl::Matrix $A where .matrix.size1 == .matrix.size2,
                 Bool :$balance = False,
                 gsl_eigen_sort_t  :$sort,
                 Bool :$schur-vectors = False,
                 Bool :$schur = False
                 --> List) {
    fail X::Libgsl.new: errno => GSL_FAILURE, error => "The matrix has the wrong size"
        if $A.matrix.size1 != ($!vectors ?? $!wsv.size !! $!ws.size);

    my @output;
    my Math::Libgsl::Vector::Complex64 $eval .= new: $A.matrix.size1;
    my Math::Libgsl::Matrix::Complex64 $evec;
    my Math::Libgsl::Matrix $Z;
    $Z .= new: $A.matrix.size1, $A.matrix.size1 if $schur-vectors;

    if $!vectors {
      $evec .= new: $A.matrix.size1, $A.matrix.size2;
      gsl_eigen_nonsymmv_params($balance ?? 1 !! 0, $!wsv);
      if $schur-vectors {
        my $ret = gsl_eigen_nonsymmv_Z($A.matrix, $eval.vector, $evec.matrix, $Z.matrix, $!wsv);
        fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues, eigenvectors, and Schur vectors"
            if $ret ≠ GSL_SUCCESS;
        @output := $eval, $evec, $Z;
      } else {
        my $ret = gsl_eigen_nonsymmv($A.matrix, $eval.vector, $evec.matrix, $!wsv);
        fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues and eigenvectors" if $ret ≠ GSL_SUCCESS;
        @output := $eval, $evec;
      }
      with $sort {
        my $ret = gsl_eigen_nonsymmv_sort($eval.vector, $evec.matrix, $sort);
        fail X::Libgsl.new: errno => $ret, error => "Can't sort eigenvalues and eigenvectors" if $ret ≠ GSL_SUCCESS;
      }
    } else {
      gsl_eigen_nonsymm_params($schur ?? 1 !! 0, $balance ?? 1 !! 0, $!ws);
      if $schur-vectors {
        my $ret = gsl_eigen_nonsymm_Z($A.matrix, $eval.vector, $Z.matrix, $!ws);
        fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues and Schur vectors" if $ret ≠ GSL_SUCCESS;
        @output := $eval, $Z;
      } else {
        my $ret = gsl_eigen_nonsymm($A.matrix, $eval.vector, $!ws);
        fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues" if $ret ≠ GSL_SUCCESS;
        @output[0] := $eval;
      }
    }

    return @output;
  }
}

class RealGenSymm {
  has gsl_eigen_gensymm_workspace  $.ws;
  has gsl_eigen_gensymmv_workspace $.wsv;
  has Bool                         $.vectors;

  multi method new(Int $size!, Bool $vectors! where .so)     { self.bless(:$size, :vectors)  }
  multi method new(Int $size!, Bool $vectors! where ! .so)   { self.bless(:$size, :!vectors) }
  multi method new(Int $size!)                               { self.bless(:$size, :!vectors) }
  multi method new(Int :$size!, Bool :$vectors! where .so)   { self.bless(:$size, :vectors)  }
  multi method new(Int :$size!, Bool :$vectors! where ! .so) { self.bless(:$size, :!vectors) }
  multi method new(Int :$size!)                              { self.bless(:$size, :!vectors) }

  submethod BUILD(Int :$size!, Bool :$!vectors) {
    if $!vectors {
      $!wsv = gsl_eigen_gensymmv_alloc($size);
    } else {
      $!ws = gsl_eigen_gensymm_alloc($size);
    }
  }
  submethod DESTROY {
    if $!vectors {
      gsl_eigen_gensymmv_free($!wsv);
    } else {
      gsl_eigen_gensymm_free($!ws);
    }
  }
  method compute(
      Math::Libgsl::Matrix $A where .matrix.size1 == .matrix.size2,
      Math::Libgsl::Matrix $B where .matrix.size1 == .matrix.size2 && .matrix.size1 == $A.matrix.size1,
      gsl_eigen_sort_t :$sort
      --> List) {
    fail X::Libgsl.new: errno => GSL_FAILURE, error => "The matrices have the wrong size"
        if $A.matrix.size1 != ($!vectors ?? $!wsv.size !! $!ws.size);

    my @output;
    my Math::Libgsl::Vector $eval .= new: $A.matrix.size1;
    my Math::Libgsl::Matrix $evec;

    if $!vectors {
      $evec .= new: $A.matrix.size1, $A.matrix.size2;
      my $ret = gsl_eigen_gensymmv($A.matrix, $B.matrix, $eval.vector, $evec.matrix, $!wsv);
      fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues and eigenvectors" if $ret ≠ GSL_SUCCESS;
      @output := $eval, $evec;
      with $sort {
        $ret = gsl_eigen_gensymmv_sort($eval.vector, $evec.matrix, $sort);
        fail X::Libgsl.new: errno => $ret, error => "Can't sort eigenvalues and eigenvectors" if $ret ≠ GSL_SUCCESS;
      }
    } else {
      my $ret = gsl_eigen_gensymm($A.matrix, $B.matrix, $eval.vector, $!ws);
      fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues" if $ret ≠ GSL_SUCCESS;
      @output[0] := $eval;
    }

    return @output;
  }
}

class ComplexGenHerm {
  has gsl_eigen_genherm_workspace  $.ws;
  has gsl_eigen_genhermv_workspace $.wsv;
  has Bool                         $.vectors;

  multi method new(Int $size!, Bool $vectors! where .so)     { self.bless(:$size, :vectors)  }
  multi method new(Int $size!, Bool $vectors! where ! .so)   { self.bless(:$size, :!vectors) }
  multi method new(Int $size!)                               { self.bless(:$size, :!vectors) }
  multi method new(Int :$size!, Bool :$vectors! where .so)   { self.bless(:$size, :vectors)  }
  multi method new(Int :$size!, Bool :$vectors! where ! .so) { self.bless(:$size, :!vectors) }
  multi method new(Int :$size!)                              { self.bless(:$size, :!vectors) }

  submethod BUILD(Int :$size!, Bool :$!vectors) {
    if $!vectors {
      $!wsv = gsl_eigen_genhermv_alloc($size);
    } else {
      $!ws = gsl_eigen_genherm_alloc($size);
    }
  }
  submethod DESTROY {
    if $!vectors {
      gsl_eigen_genhermv_free($!wsv);
    } else {
      gsl_eigen_genherm_free($!ws);
    }
  }
  method compute(
      Math::Libgsl::Matrix::Complex64 $A where .matrix.size1 == .matrix.size2,
      Math::Libgsl::Matrix::Complex64 $B where .matrix.size1 == .matrix.size2 && .matrix.size1 == $A.matrix.size1,
      gsl_eigen_sort_t :$sort
      --> List) {
    fail X::Libgsl.new: errno => GSL_FAILURE, error => "The matrices have the wrong size"
        if $A.matrix.size1 != ($!vectors ?? $!wsv.size !! $!ws.size);

    my @output;
    my Math::Libgsl::Vector $eval .= new: $A.matrix.size1;
    my Math::Libgsl::Matrix::Complex64 $evec;

    if $!vectors {
      $evec .= new: $A.matrix.size1, $A.matrix.size2;
      my $ret = gsl_eigen_genhermv($A.matrix, $B.matrix, $eval.vector, $evec.matrix, $!wsv);
      fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues and eigenvectors" if $ret ≠ GSL_SUCCESS;
      @output := $eval, $evec;
      with $sort {
        $ret = gsl_eigen_genhermv_sort($eval.vector, $evec.matrix, $sort);
        fail X::Libgsl.new: errno => $ret, error => "Can't sort eigenvalues and eigenvectors" if $ret ≠ GSL_SUCCESS;
      }
    } else {
      my $ret = gsl_eigen_genherm($A.matrix, $B.matrix, $eval.vector, $!ws);
      fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues" if $ret ≠ GSL_SUCCESS;
      @output[0] := $eval;
    }

    return @output;
  }
}

class RealGenNonSymm {
  has gsl_eigen_gen_workspace  $.ws;
  has gsl_eigen_genv_workspace $.wsv;
  has Bool                     $.vectors;

  multi method new(Int $size!, Bool $vectors! where .so)     { self.bless(:$size, :vectors)  }
  multi method new(Int $size!, Bool $vectors! where ! .so)   { self.bless(:$size, :!vectors) }
  multi method new(Int $size!)                               { self.bless(:$size, :!vectors) }
  multi method new(Int :$size!, Bool :$vectors! where .so)   { self.bless(:$size, :vectors)  }
  multi method new(Int :$size!, Bool :$vectors! where ! .so) { self.bless(:$size, :!vectors) }
  multi method new(Int :$size!)                              { self.bless(:$size, :!vectors) }

  submethod BUILD(Int :$size!, Bool :$!vectors) {
    if $!vectors {
      $!wsv = gsl_eigen_genv_alloc($size);
    } else {
      $!ws = gsl_eigen_gen_alloc($size);
    }
  }
  submethod DESTROY {
    if $!vectors {
      gsl_eigen_genv_free($!wsv);
    } else {
      gsl_eigen_gen_free($!ws);
    }
  }
  method compute(
      Math::Libgsl::Matrix $A where .matrix.size1 == .matrix.size2,
      Math::Libgsl::Matrix $B where .matrix.size1 == .matrix.size2 && .matrix.size1 == $A.matrix.size1,
      Bool :$schur-S = False,
      Bool :$schur-T = False,
      Bool :$balance = False,
      Bool :$schur-vectors = False,
      gsl_eigen_sort_t :$sort
      --> List) {
    fail X::Libgsl.new: errno => GSL_FAILURE, error => "The matrices have the wrong size"
        if $A.matrix.size1 != ($!vectors ?? $!wsv.size !! $!ws.size);

    my @output;
    my Math::Libgsl::Vector::Complex64 $alpha .= new: $A.matrix.size1;
    my Math::Libgsl::Vector $beta .= new: $A.matrix.size1;
    my Math::Libgsl::Matrix::Complex64 $evec;
    my Math::Libgsl::Matrix $Q;
    my Math::Libgsl::Matrix $Z;
    if $schur-vectors {
      $Q .= new: $A.matrix.size1, $A.matrix.size2;
      $Z .= new: $A.matrix.size1, $A.matrix.size2;
    }

    my $ret;
    if $!vectors {
      $evec .= new: $A.matrix.size1, $A.matrix.size2;
      if $schur-vectors {
        $ret = gsl_eigen_genv_QZ($A.matrix, $B.matrix, $alpha.vector, $beta.vector, $evec.matrix, $Q.matrix, $Z.matrix, $!wsv);
        fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues, eigenvectors and Schur vectors"
            if $ret ≠ GSL_SUCCESS;
        @output := $alpha, $beta, $evec, $Q, $Z;
      } else{
        $ret = gsl_eigen_genv($A.matrix, $B.matrix, $alpha.vector, $beta.vector, $evec.matrix, $!wsv);
        fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues and eigenvectors" if $ret ≠ GSL_SUCCESS;
        @output := $alpha, $beta, $evec;
      }
      with $sort {
        $ret = gsl_eigen_genv_sort($alpha.vector, $beta.vector, $evec.matrix, $sort);
        fail X::Libgsl.new: errno => $ret, error => "Can't sort eigenvalues and eigenvectors" if $ret ≠ GSL_SUCCESS;
      }
    } else {
      gsl_eigen_gen_params($schur-S ?? 1 !! 0, $schur-T ?? 1 !! 0, $balance ?? 1 !! 0, $!ws);
      if $schur-vectors {
        $ret = gsl_eigen_gen_QZ($A.matrix, $B.matrix, $alpha.vector, $beta.vector, $Q.matrix, $Z.matrix, $!ws);
        fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues and Schur vectors" if $ret ≠ GSL_SUCCESS;
        @output := $alpha, $beta, $Q, $Z;
      } else {
        $ret = gsl_eigen_gen($A.matrix, $B.matrix, $alpha.vector, $beta.vector, $!ws);
        fail X::Libgsl.new: errno => $ret, error => "Can't find eigenvalues" if $ret ≠ GSL_SUCCESS;
        @output := $alpha, $beta;
      }
    }

    return @output;
  }
}

=begin pod

=head1 NAME

Math::Libgsl::Eigensystem - An interface to libgsl, the Gnu Scientific Library - Eigensystems

=head1 SYNOPSIS

=begin code :lang<raku>

use Math::Libgsl::Matrix;
use Math::Libgsl::Eigensystem;

my Math::Libgsl::Eigensystem::RealSymm $e .= new: 2;

my Math::Libgsl::Matrix $vm .= new: 2, 2;
$vm[0;0] = 2; $vm[0;1] = 1;
$vm[1;0] = 1; $vm[1;1] = 2

my ($eval) = $e.compute($vm);
put $eval[^2];

=end code

=head1 DESCRIPTION

Math::Libgsl::Eigensystem is an interface to the Eigensystem functions of libgsl, the Gnu Scientific Library.

This module exports six classes:

=item Math::Libgsl::Eigensystem::RealSymm
=item Math::Libgsl::Eigensystem::ComplexHerm
=item Math::Libgsl::Eigensystem::RealNonSymm
=item Math::Libgsl::Eigensystem::RealGenSymm
=item Math::Libgsl::Eigensystem::ComplexGenHerm
=item Math::Libgsl::Eigensystem::RealGenNonSymm

each encapsulates the methods and the buffers needed to create and compute the eigenvalues and the eigenvectors of different kind of matrices.

All these classes share the same constructor schema:

=head3 multi method new(Int $size!, Bool $vectors?)
=head3 multi method new(Int :$size!, Bool :$vectors?)

The constructor accepts two simple or named arguments: the size of the system we want to compute and the request to compute the eigenvectors besides the eigenvalues.

All the classes have a B<compute> method; they differ for the number and type of arguments and the return value(s).

=head2 Math::Libgsl::Eigensystem::RealSymm

This class acts on a real symmetrix matrix.

=head3 method compute(Math::Libgsl::Matrix $A where .matrix.size1 == .matrix.size2, gsl_eigen_sort_t :$sort --> List)

This method computes the eigenvalues and the eigenvectors, if selected during the initialization.
The optional named argument B<:$sort> specifies the required sort order. The symbolic names for this argument are listed in the B<Math::Libgsl::Constants> module as follows:

=item B<GSL_EIGEN_SORT_VAL_ASC>: ascending order in numerical value
=item B<GSL_EIGEN_SORT_VAL_DESC>: descending order in numerical value
=item B<GSL_EIGEN_SORT_ABS_ASC>: ascending order in magnitude
=item B<GSL_EIGEN_SORT_ABS_DESC>: descending order in magnitude

This method outputs a List of values: a single B<Math::Libgsl::Vector>, which contains the eigenvalues, and an optional B<Math::Libgsl::Matrix>, which contains the eigenvectors if they were requested.

=head2 Math::Libgsl::Eigensystem::ComplexHerm

This class acts on a complex hermitian matrix.

=head3 method compute(Math::Libgsl::Matrix::Complex64 $A where .matrix.size1 == .matrix.size2, gsl_eigen_sort_t :$sort --> List)

This method computes the eigenvalues and the eigenvectors, if selected during the initialization.
The optional named argument B<:$sort> specifies the required sort order.

This method outputs a List of values: a single B<Math::Libgsl::Vector>, which contains the eigenvalues, and an optional B<Math::Libgsl::Matrix::Complex64>, which contains the eigenvectors if they were requested.

=head2 Math::Libgsl::Eigensystem::RealNonSymm

This class acts on a complex hermitian matrix.

=head3 method compute(Math::Libgsl::Matrix $A where .matrix.size1 == .matrix.size2, Bool :$balance = False, gsl_eigen_sort_t :$sort, Bool :$schur-vectors = False, Bool :$schur = False --> List)

This method computes the eigenvalues and the eigenvectors, if selected during the initialization.
The optional named argument B<:$balance> requires that a balancing transformation is applied to the matrix prior to computing eigenvalues.
The optional named argument B<:$schur> requires that it computes the full Schur form T.
The optional named argument B<:$schur-vectors> requires that it also computes the Schur vectors.
The optional named argument B<:$sort> specifies the required sort order.

This method outputs a List of values: a single B<Math::Libgsl::Vector::Complex64>, which contains the eigenvalues, an optional B<Math::Libgsl::Matrix::Complex64>, which contains the eigenvectors if they were requested, and an optional B<Math::Libgsl::Matrix> if the Schur vectors were requested.

=head2 Math::Libgsl::Eigensystem::RealGenSymm

=head3 method compute(Math::Libgsl::Matrix $A where .matrix.size1 == .matrix.size2, Math::Libgsl::Matrix $B where .matrix.size1 == .matrix.size2 && .matrix.size1 == $A.matrix.size1, gsl_eigen_sort_t :$sort --> List)

This method computes the eigenvalues and the eigenvectors, if selected during the initialization. It requires two mandatory B<Math::Libgsl::Matrix> objects (refer to the very good C Library documentation for the meaning of those two matrices and the computation details).
The optional named argument B<:$sort> specifies the required sort order.

This method outputs a List of values: a single B<Math::Libgsl::Vector>, which contains the eigenvalues, an optional B<Math::Libgsl::Matrix>, which contains the eigenvectors if they were requested.
On exit the first matrix B<$A> is destroyed and the second one B<$B> will contain the Cholesky decomposition of the eigenvector matrix.

=head2 Math::Libgsl::Eigensystem::ComplexGenHerm

=head3 method compute(Math::Libgsl::Matrix::Complex64 $A where .matrix.size1 == .matrix.size2, Math::Libgsl::Matrix::Complex64 $B where .matrix.size1 == .matrix.size2 && .matrix.size1 == $A.matrix.size1, gsl_eigen_sort_t :$sort --> List)

This method computes the eigenvalues and the eigenvectors, if selected during the initialization. It requires two mandatory B<Math::Libgsl::Matrix::Complex64> objects (refer to the very good C Library documentation for the meaning of those two matrices and the details of the computation).
The optional named argument B<:$sort> specifies the required sort order.

This method outputs a List of values: a single B<Math::Libgsl::Vector>, which contains the eigenvalues, an optional B<Math::Libgsl::Matrix::Complex64>, which contains the eigenvectors if they were requested.
On exit the first matrix B<$A> is destroyed and the second one B<$B> will contain the Cholesky decomposition of the eigenvector matrix.

=head2 Math::Libgsl::Eigensystem::RealGenNonSymm

=head3 method compute(Math::Libgsl::Matrix $A where .matrix.size1 == .matrix.size2, Math::Libgsl::Matrix $B where .matrix.size1 == .matrix.size2 && .matrix.size1 == $A.matrix.size1, Bool :$schur-S = False, Bool :$schur-T = False, Bool :$balance = False, Bool :$schur-vectors = False, gsl_eigen_sort_t :$sort --> List)

This method computes the eigenvalues and the eigenvectors, if selected during the initialization. It requires two mandatory B<Math::Libgsl::Matrix> objects (refer to the amazing C Library documentation for the meaning of those two matrices and the details of the computation).
The optional named argument B<:$schur-S> requires that it computes the full Schur form S.
The optional named argument B<:$schur-T> requires that it computes the full Schur form T.
The optional named argument B<:$balance> requires that a balancing transformation is applied to the matrix prior to computing eigenvalues (currently ignored by the underlying C library; TBI).
The optional named argument B<:$schur-vectors> requires that it also computes the Schur vectors.
The optional named argument B<:$sort> specifies the required sort order.

This method outputs a List of values: one B<Math::Libgsl::Vector::Complex64> and one B<Math::Libgsl::Vector> object, which contain the eigenvalues (see the C library documentation for the meaning of these two vectors), an optional B<Math::Libgsl::Matrix::Complex64>, which contains the eigenvectors if they were requested. If the Schur vectors were requested the left and right Schur vectors are returned as B<Math::Libgsl::Matrix> objects.
On exit, if B<$schur-S> is True, the first matrix B<$A> will contain the Schur form S; if B<$schur-T> is True, the second matrix B<$B> will contain the Schur form T.

=head1 C Library Documentation

For more details on libgsl see L<https://www.gnu.org/software/gsl/>.
The excellent C Library manual is available here L<https://www.gnu.org/software/gsl/doc/html/index.html>, or here L<https://www.gnu.org/software/gsl/doc/latex/gsl-ref.pdf> in PDF format.

=head1 Prerequisites

This module requires the libgsl library to be installed. Please follow the instructions below based on your platform:

=head2 Debian Linux and Ubuntu 20.04

=begin code
sudo apt install libgsl23 libgsl-dev libgslcblas0
=end code

That command will install libgslcblas0 as well, since it's used by the GSL.

=head2 Ubuntu 18.04

libgsl23 and libgslcblas0 have a missing symbol on Ubuntu 18.04.
I solved the issue installing the Debian Buster version of those three libraries:

=item L<http://http.us.debian.org/debian/pool/main/g/gsl/libgslcblas0_2.5+dfsg-6_amd64.deb>
=item L<http://http.us.debian.org/debian/pool/main/g/gsl/libgsl23_2.5+dfsg-6_amd64.deb>
=item L<http://http.us.debian.org/debian/pool/main/g/gsl/libgsl-dev_2.5+dfsg-6_amd64.deb>

=head1 Installation

To install it using zef (a module management tool):

=begin code
$ zef install Math::Libgsl::Eigensystem
=end code

=head1 AUTHOR

Fernando Santagata <nando.santagata@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2021 Fernando Santagata

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
