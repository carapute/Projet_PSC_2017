function [ output_signal ] = channel( input_signal )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% plage de frequences modeliser
demi_plage = [0:1104000/256:1104000-(1104000/256)];
plage = [0:2208000/512:2208000-(2208000/512)];
nombre_un = 1;
tableau_temps = [0:1:511];   % on se place ici sur 0->512 car il ne faut pas oublier la symétrie hermitienne donc quand on repasse en temps on repasse sur 0->2208000=2*1104000
%constantes
perme_vide = 4*pi*10^-7 ;        %permeabilite du vide u0
permi_vide = 1/(36*pi)*10^-9 ;   %permittivite du vide e0
permi_rela = 2;                  %permittivité relative de l'isolant séparant deux conducteurs
Te= 1/1104000;
%parametres ligne filaire
d = 0.001           ;            % diametre section d'un fil
D = 1.5*d            ;           % ecart entre les fils
permi = 2 * permi_vide ;        % permittivite ligne
conduct = 5.65*10^7     ; % "conductivite" du materiau cuivre (1/resistivite)
longueur = 3000;
%parametre primaire de la ligne
L = (perme_vide/pi)*log(2*D/d);  %inductance linéique
C = (pi*permi_vide*permi_rela)/(log(2*D/d)); %capacité linéique
G = C*10^-3*2*pi*demi_plage; %conductance linéique
R = sqrt((perme_vide*demi_plage)/(pi*conduct))/(d*sqrt(1-(d/D)^2)); %Résistance linéique

gamma = sqrt(  (R + j*L*2*pi*demi_plage).*(G + j*C*2*pi*demi_plage)  ); %on suppose ici que l'on a pas déphasage donc alpha= gamma. Il faut regarder le doc trouvé sur internet et le compte rendu pour savoir ce qu'on choisit. LEs deux disent pas la même chose

%reponse fréquenciel avec reflexions
rep_freq = 0.5 * (1 + 50/100) * exp(- gamma * longueur)  ./ (1 - 50/100 * 50/100 * exp(-2 * gamma * longueur));
%reponse frequentielle sans reflexion
%rep_freq = 1/2*exp(-gamma*longueur);

%réponse fréquencielle symétrique
rep_freq_sym = fliplr(conj(rep_freq));

%reponse fréquencielle totale
rep_freq_tot = [rep_freq , rep_freq_sym];

%reponse impulsionnelle 
rep_imp = ifft(rep_freq_tot);

%tracé en fonction des canaux
%plot(tableau_temps, rep_imp);

%tracé en fonction du temps
plot(tableau_temps*Te, rep_imp);

%signal rectangle 

[ouput_signal] = conv2(rep_imp , input_signal)

end

