#!/usr/bin/env raku

# See "GNU Scientific Library" manual Chapter 15 Eigensystems, Paragraph 15.8 (II example)

use Math::Libgsl::Constants;
use Math::Libgsl::Matrix;
use Math::Libgsl::Vector;
use Math::Libgsl::Eigensystem;

my @data = -1,  1, -1, 1,
           -8,  4, -2, 1,
           27,  9,  3, 1,
           64, 16,  4, 1;
array-mat(-> $mat {
    my Math::Libgsl::Eigensystem::RealNonSymm $e .= new: :4size, :vectors;
    my ($eval, $evec) = $e.compute($mat, :sort(GSL_EIGEN_SORT_ABS_DESC));
    my Math::Libgsl::Vector::Complex64::View $vv .= new;
    for ^4 -> $i {
      printf "eigenvalue = %g%+gi\n", $eval[$i].re, $eval[$i].im;
      put "eigenvector =";
      for ^4 -> $j {
        my $v = $evec.col-view($vv, $i);
        printf "%g%+gi\n", $v[$j].re, $v[$j].im;
      }
    }
  },
  4, 4, @data);
