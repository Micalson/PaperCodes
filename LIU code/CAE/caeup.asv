function cae = caeup(cae, x)  %Ïàµ±ÓÚ±àÂë
    cae.i = x;
    
    %init temp vars for parrallel processing
    pa  = cell(size(cae.a)) ;  %1*10 cell
                                       % cae.a  %[600x32x32 double]*10
    pi  = cae.i ;  %1*28*28 double
    pik = cae.ik ; %1*10 cell
    pb  = cae.b ; %1*10 cell

    for j = 1 : numel(cae.a) %10
        z = 0;
        for i = 1 : numel(pi) %1            
            z = z + convn(pi{i}, pik{i}{j}, 'full');
        end
        pa{j} = sigm(z + pb{j});

        %  Max pool.
        if ~isequal(cae.scale, [1 1 1])
            pa{j} = max3d(pa{j}, cae.M);
        end

    end

    cae.a = pa;

end
