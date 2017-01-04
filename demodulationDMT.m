function [suite_symboles_out] = demodulationDMT(signal_recu,nb_symbs_to_process,nombre_canaux)

% signal_recu = signal re�u apr�s passage dans le canal
% h_eval_mod = module de la r�ponse impulsionnelle du canal, identifi�e
% nombre_canaux = nombre de canaux utilis�s
% prefixe_cyclique = longueur du CP
% tab = vecteur table allocation des bits

for i=1:nombre_canaux
    %% Transformer le tableau � N dimensions en un vecteur %%
    for j=1:nb_symbs_to_process
        dataDemod(j) = signal_recu(j,i);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% Suppression du CP         %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %signal_recu=signal_recu(v+1:2*N+v);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FFT et �galisation du signal %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    signal_before_egalisation = fft(dataDemod);
    
    %signal_fft = x./h_eval_mod; % �galisation
    
    
    %% Regroupement des signaux modul�s dans un tableau global %%
    
    for f=1:length(signal_before_egalisation)
        suite_symboles_out(f,i) = signal_before_egalisation(f);
    end
end
end
