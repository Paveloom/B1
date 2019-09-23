module module_c
implicit none
     
     contains

     subroutine example(mpiRank)
     
     integer(4), intent(in) :: mpiRank ! Ранг процесса
     
     write(*,'(3x, a, 3x, i1)') 'Ранг процесса:', mpiRank
     
     end subroutine
     
end module module_c