% toujours noter la cadence d'échantillonnage -> période d'échantillonnage
% mesurer temps que l'expérience prend avec une montre externe (prendre
% 20-30 sec pour être suffisamment précis)

% h: période d'échantillonnage A CONNAITRE!

% pour cette expérience on suppose 16 Hz


% suivre le prof:

fe = 200;
h = 1/fe;

sig = sin(2*pi*16*(1:300)* h);

% 16: fréquence du système
% 300 nombre d'échantillons

plot(sig)
figure(1)

% oscillation amortie qui ressemble au système avec la règle
sig1 = sig .* exp(-1/0.5 * (1:300)*h);
clf
plot(sig1)
figure(1)

sig1b = sig1+randn(1,300); % sig1 bruité
clf
plot(sig1b)
figure(1)

sig1bb = sig1 + 3*randn(1,300); % super bruité
clf
plot(sig1bb)
figure(1)

sig1b = sig1 + 0.2*randn(1,300);
clf
plot(sig1b)
figure(1)

% montrer le hasard
hold on
sig1b = sig1 + 0.2*randn(1,300);
plot(sig1b)
figure(1)

% objectif: nettoyer ça

clf
plot(sig1b)
figure(1)

% on a un signal symmetrique autour de 0 donc on va ajouter du offset
sig1b = sig1 + 0.2*randn(1,300) + 1.5;
clf
plot(sig1b)
figure(1)

fsig1b = fft(sig1b); % signal fourier

fsig1b(1:10)

clf
plot(abs(fsig1b))
figure(1)

% à droite : bruit
% à gauche: oscillations
% tout à gauche: offset

% quoiqu'on fasse, le bout de notre fenêtre figure va être notre fréquence
% d'échantillonnage

% bruité et renormalisé à zéro
sig1bn = sig1b - mean(sig1b);
fsig1bn = fft(sig1bn);

clf
plot(abs(fsig1bn))
figure(1)

% on veut nettoyer ça mnt

% effet stroboscopique (-> échantillonnage) change comment on "voit" les
% fréquences du système depuis le numérique

% on voit 2 pics sur notre plot, mais ce qu'on perçoit c'est la
% symétrisation en négatif de notre phaseur à gauche (on devrait "rouler"
% le plot pour que les 2 pics se superposent)

% sin(wt) = 1/2i * e^(jwt) - 1/2i * e^(-jwt) formule du sin en phaseur
% (1/2i)* = -1/2i complexe conjugué
% cos(wt) = 1/2 * e^(jwt) + 1/2 * e^(-jwt)

% on trouve 25 sur le plot (pic de gauche) avec la petite croix
fsig1bn(25)
fsig1bn(24)
fsig1bn(26)

% on voit 277 sur le plot (avec la petite croix) et on remarque que ces
% valeurs sont complexes conjuguées
fsig1bn(277)
fsig1bn(25)

% fréquence max qu'on peut prendre c'est 1/2 * fréquence échantillonnage 
% après on voit un miroir -> à 150 = 300/2 -> fréquence de Nyquist

fsig1bn(151) % réel (150e -> 300/2) 

% on construit un filtre passe-bas d'ordre 4 avec wn = 26 (fréquence de coupure)
%help butter

[B, A] = butter(4, 26/150)

sum(B)

sum(A)

% sum(A) et sum(B) sont identiques!

[B, A] = butter(8, 26/150)

sum(B)

% help filter

[B, A] = butter(4, 26/150)
% 8 c'est trop, 4 c'est un bon milieu

% signal filtré

sig1bnf = filter(B,A, sig1bn);
clf
plot(sig1bnf)
figure(1)
% signal un peu vaseux, pollution des fréquences hautes dans les fréquences
% basses

fsig1bnf = fft(sig1bnf);
clf
plot(abs(fsig1bnf))
figure(1)

% passe-haut -> 23 trouvé sur la figure pour bien laisser passer
% l'entonnoir
[Bh, Ah] = butter(4,23/150,'high'); % -> 'high' pour passe-haut
sum(Bh) % doit être 0 sinon on a pas un passe-haut

% sig 1 bruité normalisé filtré passe-haut
sig1bnfh = filter(Bh, Ah, sig1bnf);

clf
plot(sig1bnfh)
figure(1)

clf
plot(sig1)
hold on
plot(sig1bnf)
figure(1)
% on remarque du déphasage entre les signaux

clf
plot(sig1)
hold on
plot(sig1bnfh)
figure(1)
% le déphasage disparaît

fsig1bnfh = fft(sig1bnfh);
clf
plot(abs(fsig1bnfh))
figure(1)

clf 
plot(sig1bn)
figure(1)

clf
plot(abs(fft(sig1bn)))
figure(1)

clf
sigs = sin(2*pi*(5/1.5)*(1:300)*h);
plot(sigs)
figure(1)

clf
plot(abs(fft(sigs)))
figure(1)

clf
plot(sigs)
figure(1)

clf
plot(abs(fft(sigs(1:287))))
figure(1)

clf
plot(hann(300)')
figure(1)

% si on veut améliorer le temps on doit détruire la fréquence et si on veut
% améliorer la fréquence on doit détruire le temps

% sig1 bruité normalisé fenêtré
sig1bnw = sig1bn.*(hann(300)');
clf
plot(sig1bnw)
figure(1)

clf 
plot(abs(fft(sig1bnw)))
figure(1)

%close all

% THEORIE UTILE POUR L'EXAMEN

% réflexe : toujours noter la fréquence d'échantillonnage

h = 0.005; % ms

fe = 1/h; % = 200 Hz

% ∆f = fe / N
% fréquence entre échantillons
% N: nombre d'échantillons


% FORMULEs A CONNAITRE -> POUR EXAM
% n_chapeau / N * fe = f0 -> fréquence originale du système
% ∆t * ∆f = (h * fe) / N = 1/N

% ∆t on ferme les yeux (échantillonnage)
% ∆f point le plus à droite de notre figure

% (25-1) / 300 * 200 = 16 Hz! -> fréquence d'origine