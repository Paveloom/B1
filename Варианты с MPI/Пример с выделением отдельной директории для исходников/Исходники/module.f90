module module
use mpi
implicit none

     contains
     
     subroutine example(mpiRank)
     
     integer(4), intent(in) :: mpiRank ! Ранг процесса
     
     write(*,'(3x, a, 3x, i1)') 'Ранг процесса:', mpiRank
     
     end subroutine
     
end module
