function re = cart_distance(p1,p2)
    
    difx = p1(1)-p2(1);
    dify = p1(2)-p2(2);

    
    re  = sqrt((difx)^2 + (dify)^2);

end