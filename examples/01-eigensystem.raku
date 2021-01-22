#!/usr/bin/env raku

# See "GNU Scientific Library" manual Chapter 15 Eigensystems, Paragraph 15.8 (I example)

use Math::Libgsl::Constants;
use Math::Libgsl::Matrix;
use Math::Libgsl::Vector;
use Math::Libgsl::Eigensystem;

my @data = 1, ½, ⅓, ¼,
           ½, ⅓, ¼, ⅕,
           ⅓, ¼, ⅕, ⅙,
           ¼, ⅕, ⅙, ⅐;
array-mat(-> $mat {
    my Math::Libgsl::Eigensystem::RealSymm $e .= new: :4size, :vectors;
    my ($eval, $evec) = $e.compute($mat, :sort(GSL_EIGEN_SORT_ABS_ASC));
    my Math::Libgsl::Vector::View $vv .= new;
    for ^4 -> $i {
      put "eigenvalue = " ~ $eval[$i].fmt('%g');
      put "eigenvector = { $evec.col-view($vv, $i)[^4]».fmt('%g') }";
    }
  },
  4, 4, @data);
