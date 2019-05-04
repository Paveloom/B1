module TestM
implicit none

contains

     subroutine TestC
     implicit none
     
     write(*,'(/,4x,a,/)') 'Я работаю.'

     end subroutine

end
