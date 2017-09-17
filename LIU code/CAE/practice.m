clc
clear all
scae = {
    struct('outputmaps', 10, 'inputkernel', [1 5 5], 'outputkernel', [1 5 5], 'scale', [1 2 2], 'sigma', 0.1, 'momentum', 0.9, 'noise', 0)
    struct('outputmaps', 1, 'inputkernel', [1 5 5], 'outputkernel', [1 5 5], 'scale', [1 2 2], 'sigma', 0.1, 'momentum', 0.9, 'noise', 0)

};
for l = 1 : numel(scae)
cae = scae{l}
end