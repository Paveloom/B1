program main
use module
implicit none
     
     ! Стандартные и вспомогательные переменные MPI
     integer(4) mpiRank ! Ранг процесса
     integer(4) mpiErr  ! Переменная ошибки

     ! Инициализация MPI
     call mpi_init(mpiErr)
     
     ! Определение mpiRank
     call mpi_comm_rank(MPI_COMM_WORLD, mpiRank, mpiErr)
     
     call example(mpiRank)

     call mpi_finalize(mpiErr)

end
