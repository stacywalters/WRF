subroutine d1fgkf ( ido, ip, l1, idl1, cc, c1, c2, in1, ch, ch2, in2, wa )

!*****************************************************************************80
!
!! D1FGKF is an FFTPACK5 auxiliary routine.
!
!  License:
!
!    Licensed under the GNU General Public License (GPL).
!
!  Modified:
!
!    07 February 2006
!
!  Author:
!
!    Original real single precision by Paul Swarztrauber, Richard Valent.
!    Real double precision version by John Burkardt.
!
!  Reference:
!
!    Paul Swarztrauber,
!    Vectorizing the Fast Fourier Transforms,
!    in Parallel Computations,
!    edited by G. Rodrigue,
!    Academic Press, 1982.
!
!    Paul Swarztrauber,
!    Fast Fourier Transform Algorithms for Vector Computers,
!    Parallel Computing, pages 45-63, 1984.
!
!  Parameters:
!
  implicit none

  integer ( kind = 4 ) idl1
  integer ( kind = 4 ) ido
  integer ( kind = 4 ) in1
  integer ( kind = 4 ) in2
  integer ( kind = 4 ) ip
  integer ( kind = 4 ) l1

  real ( kind = 8 ) ai1
  real ( kind = 8 ) ai2
  real ( kind = 8 ) ar1
  real ( kind = 8 ) ar1h
  real ( kind = 8 ) ar2
  real ( kind = 8 ) ar2h
  real ( kind = 8 ) arg
  real ( kind = 8 ) c1(in1,ido,l1,ip)
  real ( kind = 8 ) c2(in1,idl1,ip)
  real ( kind = 8 ) cc(in1,ido,ip,l1)
  real ( kind = 8 ) ch(in2,ido,l1,ip)
  real ( kind = 8 ) ch2(in2,idl1,ip)
  real ( kind = 8 ) dc2
  real ( kind = 8 ) dcp
  real ( kind = 8 ) ds2
  real ( kind = 8 ) dsp
  integer ( kind = 4 ) i
  integer ( kind = 4 ) ic
  integer ( kind = 4 ) idij
  integer ( kind = 4 ) idp2
  integer ( kind = 4 ) ik
  integer ( kind = 4 ) ipp2
  integer ( kind = 4 ) ipph
  integer ( kind = 4 ) is
  integer ( kind = 4 ) j
  integer ( kind = 4 ) j2
  integer ( kind = 4 ) jc
  integer ( kind = 4 ) k
  integer ( kind = 4 ) l
  integer ( kind = 4 ) lc
  integer ( kind = 4 ) nbd
  real ( kind = 8 ) tpi
  real ( kind = 8 ) wa(ido)

  tpi = 2.0D+00 * 4.0D+00 * atan ( 1.0D+00 )
  arg = tpi / real ( ip, kind = 8 )
  dcp = cos ( arg )
  dsp = sin ( arg )
  ipph = ( ip + 1 ) / 2
  ipp2 = ip + 2
  idp2 = ido + 2
  nbd = ( ido - 1 ) / 2

  if ( ido == 1 ) then

    do ik = 1, idl1
      c2(1,ik,1) = ch2(1,ik,1)
    end do

  else

    do ik = 1, idl1
      ch2(1,ik,1) = c2(1,ik,1)
    end do

    do j = 2, ip
      do k = 1, l1
        ch(1,1,k,j) = c1(1,1,k,j)
      end do
    end do

    if ( l1 < nbd ) then

      is = -ido

      do j = 2, ip
        is = is + ido
        do k = 1, l1
          idij = is
          do i = 3, ido, 2
            idij = idij + 2
            ch(1,i-1,k,j) = wa(idij-1)*c1(1,i-1,k,j)+wa(idij) *c1(1,i,k,j)
            ch(1,i,k,j) = wa(idij-1)*c1(1,i,k,j)-wa(idij) *c1(1,i-1,k,j)
          end do
        end do
      end do

    else

      is = -ido

      do j = 2, ip
        is = is + ido
        idij = is
        do i = 3, ido, 2
          idij = idij + 2
          do k = 1, l1
            ch(1,i-1,k,j) = wa(idij-1)*c1(1,i-1,k,j)+wa(idij) *c1(1,i,k,j)
            ch(1,i,k,j) = wa(idij-1)*c1(1,i,k,j)-wa(idij) *c1(1,i-1,k,j)
          end do
        end do
      end do

    end if

    if ( nbd < l1 ) then

      do j = 2, ipph
        jc = ipp2 - j
        do i = 3, ido, 2
          do k = 1, l1
            c1(1,i-1,k,j) = ch(1,i-1,k,j)+ch(1,i-1,k,jc)
            c1(1,i-1,k,jc) = ch(1,i,k,j)-ch(1,i,k,jc)
            c1(1,i,k,j) = ch(1,i,k,j)+ch(1,i,k,jc)
            c1(1,i,k,jc) = ch(1,i-1,k,jc)-ch(1,i-1,k,j)
          end do
        end do
      end do

    else

      do j = 2, ipph
        jc = ipp2 - j
        do k = 1, l1
          do i = 3, ido, 2
            c1(1,i-1,k,j) = ch(1,i-1,k,j)+ch(1,i-1,k,jc)
            c1(1,i-1,k,jc) = ch(1,i,k,j)-ch(1,i,k,jc)
            c1(1,i,k,j) = ch(1,i,k,j)+ch(1,i,k,jc)
            c1(1,i,k,jc) = ch(1,i-1,k,jc)-ch(1,i-1,k,j)
          end do
        end do
      end do

    end if

  end if

  do j = 2, ipph
    jc = ipp2 - j
    do k = 1, l1
      c1(1,1,k,j) = ch(1,1,k,j)+ch(1,1,k,jc)
      c1(1,1,k,jc) = ch(1,1,k,jc)-ch(1,1,k,j)
    end do
  end do

  ar1 = 1.0D+00
  ai1 = 0.0D+00

  do l = 2, ipph

    lc = ipp2 - l
    ar1h = dcp * ar1 - dsp * ai1
    ai1 = dcp * ai1 + dsp * ar1
    ar1 = ar1h

    do ik = 1, idl1
      ch2(1,ik,l) = c2(1,ik,1)+ar1*c2(1,ik,2)
      ch2(1,ik,lc) = ai1*c2(1,ik,ip)
    end do

    dc2 = ar1
    ds2 = ai1
    ar2 = ar1
    ai2 = ai1

    do j = 3, ipph
      jc = ipp2 - j
      ar2h = dc2 * ar2 - ds2 * ai2
      ai2 = dc2 * ai2 + ds2 * ar2
      ar2 = ar2h
      do ik = 1, idl1
        ch2(1,ik,l) = ch2(1,ik,l)+ar2*c2(1,ik,j)
        ch2(1,ik,lc) = ch2(1,ik,lc)+ai2*c2(1,ik,jc)
      end do
    end do

  end do

  do j = 2, ipph
    do ik = 1, idl1
      ch2(1,ik,1) = ch2(1,ik,1)+c2(1,ik,j)
    end do
  end do

  if ( ido < l1 ) then

    do i = 1, ido
      do k = 1, l1
        cc(1,i,1,k) = ch(1,i,k,1)
      end do
    end do

  else

    do k = 1, l1
      do i = 1, ido
        cc(1,i,1,k) = ch(1,i,k,1)
      end do
    end do

  end if

  do j = 2, ipph
    jc = ipp2 - j
    j2 = j+j
    do k = 1, l1
      cc(1,ido,j2-2,k) = ch(1,1,k,j)
      cc(1,1,j2-1,k) = ch(1,1,k,jc)
    end do
  end do

  if ( ido == 1 ) then
    return
  end if

  if ( nbd < l1 ) then

    do j = 2, ipph
      jc = ipp2 - j
      j2 = j + j
      do i = 3, ido, 2
        ic = idp2 - i
        do k = 1, l1
          cc(1,i-1,j2-1,k) = ch(1,i-1,k,j)+ch(1,i-1,k,jc)
          cc(1,ic-1,j2-2,k) = ch(1,i-1,k,j)-ch(1,i-1,k,jc)
          cc(1,i,j2-1,k) = ch(1,i,k,j)+ch(1,i,k,jc)
          cc(1,ic,j2-2,k) = ch(1,i,k,jc)-ch(1,i,k,j)
        end do
      end do
   end do

  else

    do j = 2, ipph
      jc = ipp2 - j
      j2 = j + j
      do k = 1, l1
        do i = 3, ido, 2
          ic = idp2 - i
          cc(1,i-1,j2-1,k)  = ch(1,i-1,k,j) + ch(1,i-1,k,jc)
          cc(1,ic-1,j2-2,k) = ch(1,i-1,k,j) - ch(1,i-1,k,jc)
          cc(1,i,j2-1,k)    = ch(1,i,k,j)   + ch(1,i,k,jc)
          cc(1,ic,j2-2,k)   = ch(1,i,k,jc)  - ch(1,i,k,j)
        end do
      end do
    end do

  end if

  return
end
