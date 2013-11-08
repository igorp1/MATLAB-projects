clc
clf
speed = 5;

location = input('Enter the starting location([num1,num2]): ');
destination = input('Enter the final location([num1,num2]): ');

delta = (destination-location).*(speed/cart_distance(destination,location));


plot([location(1) destination(1)],[location(2) destination(2)],'r*')

hold on

while cart_distance(destination,location) > 0
    
    pause(1)
    location = location + delta;
    plot(location(1),location(2) ,'bo')
    
    if (cart_distance(destination,location) < cart_distance(location,location + delta))
        
        location = location + (destination-location);
        pause(.5)
        plot(location(1),location(2) ,'yo','MarkerFaceColor',[255,215,0]/255)
        text(location(1),location(2),'ARRIVED!')
        
    end
end
