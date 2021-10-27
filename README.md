[![Actions Status](https://github.com/frithnanth/raku-Math-Libgsl-Eigensystem/workflows/test/badge.svg)](https://github.com/frithnanth/raku-Math-Libgsl-Eigensystem/actions)

NAME
====

Math::Libgsl::Eigensystem - An interface to libgsl, the Gnu Scientific Library - Eigensystems

SYNOPSIS
========

```raku
use Math::Libgsl::Matrix;
use Math::Libgsl::Eigensystem;

my Math::Libgsl::Eigensystem::RealSymm $e .= new: 2;

my Math::Libgsl::Matrix $vm .= new: 2, 2;
$vm[0;0] = 2; $vm[0;1] = 1;
$vm[1;0] = 1; $vm[1;1] = 2

my ($eval) = $e.compute($vm);
put $eval[^2];
```

DESCRIPTION
===========

Math::Libgsl::Eigensystem is an interface to the Eigensystem functions of libgsl, the Gnu Scientific Library.

This module exports six classes:

  * Math::Libgsl::Eigensystem::RealSymm

  * Math::Libgsl::Eigensystem::ComplexHerm

  * Math::Libgsl::Eigensystem::RealNonSymm

  * Math::Libgsl::Eigensystem::RealGenSymm

  * Math::Libgsl::Eigensystem::ComplexGenHerm

  * Math::Libgsl::Eigensystem::RealGenNonSymm

each encapsulates the methods and the buffers needed to create and compute the eigenvalues and the eigenvectors of different kind of matrices.

All these classes share the same constructor schema:

### multi method new(Int $size!, Bool $vectors?)

### multi method new(Int :$size!, Bool :$vectors?)

The constructor accepts two simple or named arguments: the size of the system we want to compute and the request to compute the eigenvectors besides the eigenvalues.

All the classes have a **compute** method; they differ for the number and type of arguments and the return value(s).

Math::Libgsl::Eigensystem::RealSymm
-----------------------------------

This class acts on a real symmetrix matrix.

### method compute(Math::Libgsl::Matrix $A where .matrix.size1 == .matrix.size2, gsl_eigen_sort_t :$sort --> List)

This method computes the eigenvalues and the eigenvectors, if selected during the initialization. The optional named argument **:$sort** specifies the required sort order. The symbolic names for this argument are listed in the **Math::Libgsl::Constants** module as follows:

  * **GSL_EIGEN_SORT_VAL_ASC**: ascending order in numerical value

  * **GSL_EIGEN_SORT_VAL_DESC**: descending order in numerical value

  * **GSL_EIGEN_SORT_ABS_ASC**: ascending order in magnitude

  * **GSL_EIGEN_SORT_ABS_DESC**: descending order in magnitude

This method outputs a List of values: a single **Math::Libgsl::Vector**, which contains the eigenvalues, and an optional **Math::Libgsl::Matrix**, which contains the eigenvectors if they were requested.

Math::Libgsl::Eigensystem::ComplexHerm
--------------------------------------

This class acts on a complex hermitian matrix.

### method compute(Math::Libgsl::Matrix::Complex64 $A where .matrix.size1 == .matrix.size2, gsl_eigen_sort_t :$sort --> List)

This method computes the eigenvalues and the eigenvectors, if selected during the initialization. The optional named argument **:$sort** specifies the required sort order.

This method outputs a List of values: a single **Math::Libgsl::Vector**, which contains the eigenvalues, and an optional **Math::Libgsl::Matrix::Complex64**, which contains the eigenvectors if they were requested.

Math::Libgsl::Eigensystem::RealNonSymm
--------------------------------------

This class acts on a complex hermitian matrix.

### method compute(Math::Libgsl::Matrix $A where .matrix.size1 == .matrix.size2, Bool :$balance = False, gsl_eigen_sort_t :$sort, Bool :$schur-vectors = False, Bool :$schur = False --> List)

This method computes the eigenvalues and the eigenvectors, if selected during the initialization. The optional named argument **:$balance** requires that a balancing transformation is applied to the matrix prior to computing eigenvalues. The optional named argument **:$schur** requires that it computes the full Schur form T. The optional named argument **:$schur-vectors** requires that it also computes the Schur vectors. The optional named argument **:$sort** specifies the required sort order.

This method outputs a List of values: a single **Math::Libgsl::Vector::Complex64**, which contains the eigenvalues, an optional **Math::Libgsl::Matrix::Complex64**, which contains the eigenvectors if they were requested, and an optional **Math::Libgsl::Matrix** if the Schur vectors were requested.

Math::Libgsl::Eigensystem::RealGenSymm
--------------------------------------

### method compute(Math::Libgsl::Matrix $A where .matrix.size1 == .matrix.size2, Math::Libgsl::Matrix $B where .matrix.size1 == .matrix.size2 && .matrix.size1 == $A.matrix.size1, gsl_eigen_sort_t :$sort --> List)

This method computes the eigenvalues and the eigenvectors, if selected during the initialization. It requires two mandatory **Math::Libgsl::Matrix** objects (refer to the very good C Library documentation for the meaning of those two matrices and the computation details). The optional named argument **:$sort** specifies the required sort order.

This method outputs a List of values: a single **Math::Libgsl::Vector**, which contains the eigenvalues, an optional **Math::Libgsl::Matrix**, which contains the eigenvectors if they were requested. On exit the first matrix **$A** is destroyed and the second one **$B** will contain the Cholesky decomposition of the eigenvector matrix.

Math::Libgsl::Eigensystem::ComplexGenHerm
-----------------------------------------

### method compute(Math::Libgsl::Matrix::Complex64 $A where .matrix.size1 == .matrix.size2, Math::Libgsl::Matrix::Complex64 $B where .matrix.size1 == .matrix.size2 && .matrix.size1 == $A.matrix.size1, gsl_eigen_sort_t :$sort --> List)

This method computes the eigenvalues and the eigenvectors, if selected during the initialization. It requires two mandatory **Math::Libgsl::Matrix::Complex64** objects (refer to the very good C Library documentation for the meaning of those two matrices and the details of the computation). The optional named argument **:$sort** specifies the required sort order.

This method outputs a List of values: a single **Math::Libgsl::Vector**, which contains the eigenvalues, an optional **Math::Libgsl::Matrix::Complex64**, which contains the eigenvectors if they were requested. On exit the first matrix **$A** is destroyed and the second one **$B** will contain the Cholesky decomposition of the eigenvector matrix.

Math::Libgsl::Eigensystem::RealGenNonSymm
-----------------------------------------

### method compute(Math::Libgsl::Matrix $A where .matrix.size1 == .matrix.size2, Math::Libgsl::Matrix $B where .matrix.size1 == .matrix.size2 && .matrix.size1 == $A.matrix.size1, Bool :$schur-S = False, Bool :$schur-T = False, Bool :$balance = False, Bool :$schur-vectors = False, gsl_eigen_sort_t :$sort --> List)

This method computes the eigenvalues and the eigenvectors, if selected during the initialization. It requires two mandatory **Math::Libgsl::Matrix** objects (refer to the amazing C Library documentation for the meaning of those two matrices and the details of the computation). The optional named argument **:$schur-S** requires that it computes the full Schur form S. The optional named argument **:$schur-T** requires that it computes the full Schur form T. The optional named argument **:$balance** requires that a balancing transformation is applied to the matrix prior to computing eigenvalues (currently ignored by the underlying C library; TBI). The optional named argument **:$schur-vectors** requires that it also computes the Schur vectors. The optional named argument **:$sort** specifies the required sort order.

This method outputs a List of values: one **Math::Libgsl::Vector::Complex64** and one **Math::Libgsl::Vector** object, which contain the eigenvalues (see the C library documentation for the meaning of these two vectors), an optional **Math::Libgsl::Matrix::Complex64**, which contains the eigenvectors if they were requested. If the Schur vectors were requested the left and right Schur vectors are returned as **Math::Libgsl::Matrix** objects. On exit, if **$schur-S** is True, the first matrix **$A** will contain the Schur form S; if **$schur-T** is True, the second matrix **$B** will contain the Schur form T.

C Library Documentation
=======================

For more details on libgsl see [https://www.gnu.org/software/gsl/](https://www.gnu.org/software/gsl/). The excellent C Library manual is available here [https://www.gnu.org/software/gsl/doc/html/index.html](https://www.gnu.org/software/gsl/doc/html/index.html), or here [https://www.gnu.org/software/gsl/doc/latex/gsl-ref.pdf](https://www.gnu.org/software/gsl/doc/latex/gsl-ref.pdf) in PDF format.

Prerequisites
=============

This module requires the libgsl library to be installed. Please follow the instructions below based on your platform:

Debian Linux and Ubuntu 20.04
-----------------------------

    sudo apt install libgsl23 libgsl-dev libgslcblas0

That command will install libgslcblas0 as well, since it's used by the GSL.

Ubuntu 18.04
------------

libgsl23 and libgslcblas0 have a missing symbol on Ubuntu 18.04. I solved the issue installing the Debian Buster version of those three libraries:

  * [http://http.us.debian.org/debian/pool/main/g/gsl/libgslcblas0_2.5+dfsg-6_amd64.deb](http://http.us.debian.org/debian/pool/main/g/gsl/libgslcblas0_2.5+dfsg-6_amd64.deb)

  * [http://http.us.debian.org/debian/pool/main/g/gsl/libgsl23_2.5+dfsg-6_amd64.deb](http://http.us.debian.org/debian/pool/main/g/gsl/libgsl23_2.5+dfsg-6_amd64.deb)

  * [http://http.us.debian.org/debian/pool/main/g/gsl/libgsl-dev_2.5+dfsg-6_amd64.deb](http://http.us.debian.org/debian/pool/main/g/gsl/libgsl-dev_2.5+dfsg-6_amd64.deb)

Installation
============

To install it using zef (a module management tool):

    $ zef install Math::Libgsl::Eigensystem

AUTHOR
======

Fernando Santagata <nando.santagata@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2021 Fernando Santagata

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

