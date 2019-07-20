module module
use omp_lib
implicit none

     contains
     
     subroutine example
     implicit none
     
     !$omp parallel
     write(*,'(3x, a, 3x, i1)') 'Ранг процесса:', omp_get_thread_num()
     !$omp end parallel
     
     end subroutine
     
end module
