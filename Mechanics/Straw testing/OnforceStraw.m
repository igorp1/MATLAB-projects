    


   %moment at P is 0
   M_P = 0;
    
   %distance from center of mass C to pin P
   dist_PC = 14.35;
   
   %distance from bucket B to pin P
   dist_PB = 16.5;
   
   
   %distance from straw support to pin P
   dist_PS = 19.74;
   
   %weight of bar (force at :
   F_C = 221*9.81;



for i = [9 11 14]
    
    %force at B:
    data(i).forceBucket = [data(i).points] .* 9.81;
    
    
    data(i).forceStraw = dist_PS.*[data(i).forceBucket] + dist_PC*F_C;
    
    
    
    
    
end
   
   