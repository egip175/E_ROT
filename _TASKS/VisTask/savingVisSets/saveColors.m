% white: [1 1 1]
% black: [0 0 0]
% red: [1 0 0]
% green: [0 1 0] 
% blue: [0 0 1]
% brown: [0.7 0.4 0.2]
% yellow: [1 1 0]
% orange:[1 0.5 0]
% violet:[0.6 0.2 0.7]
% teal: [0 1 1]
% pink: [1 0.4 1]
% grey: [0.6 0.6 0.6]

function colors=saveColors(colorNames)

colors= ones(length(colorNames),3);

for i=1:length(colorNames)
    
    col=char(colorNames(i));
    
    switch col
        case 'w'
            colors(i,:)=[1 1 1];
        case 'k'
            colors(i,:)=[0 0 0];
        case 'r'
            colors(i,:)=[1 0 0];
        case 'bl'
            colors(i,:)=[0 0 1];
        case 'g'
            colors(i,:)=[0 1 0] ;
        case 'br'
            colors(i,:)=[0.7 0.4 0.2];
        case 'v'
            colors(i,:)=[0.6 0.2 0.7];
        case 'p'
            colors(i,:)=[1 0.4 1];
        case 't'
            colors(i,:)=[0 1 1];
        case 'gr'
            colors(i,:)=[0.6 0.6 0.6];
        case 'y'
            colors(i,:)=[1 1 0];
        case 'or'
            colors(i,:)=[1 0.5 0];
    end
end

colors=colors';
end