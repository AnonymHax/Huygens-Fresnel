function grid = generateRandomSquareGrid(a, b, n)

    for i = 1:n
        grid(i,:) = [((b-a).*rand(n,1) + a)];
    end
return

