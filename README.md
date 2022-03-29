This is chess, the final assignment for the Ruby course in The Odin project. 
Special Details:
The game follows all rules except the 3fold/5fold rule. This rule states that if the same game state appears 3 times, a player may request a draw. If it appears 5 times, 
a draw can be forced. I omitted this as it adds a fair amount of complexity and RAM usage for a feature that I do not believe any of my users would use. I could be wrong,
but outside of professional chess, I don't think people would even realize that they were playing in loops, let alone invoke this rule. Increasing CPU and RAM requirements
for an unwanted feature seems unwise.
The game allows you to use special moves. Castle, and En Passant are both implemented and work as intended.
Save games are implemented. Each turn is autosaved, and the player may save the game during their turn, giving it their own save file name.
The player also has the options to continue, which loads the autosave file, or load, which then presents the user with a list of save game files that they may choose from.
The game's AI is not particularly smart, but will take pieces, ranking importance, and putting the opponent into check when possible.

Thoughts:
I really enjoyed this project. It was by far the most complex I've worked on to date. It was a great feeling working on it as it moved from a board with pieces to an
actually playable game. Ironing out the bits at the end, and making sure the biggest obsticles were cleared was a very rewarding experience. I believe that if I were to
start over from scratch, I would end up with a more efficient and better coded version, and I plan on doing so. I will wait, however, as I also feel limited by the nature
of the program being limited to the terminal. While I was very happy with my results in how the game looked and performed in the terminal on my own PC, things looked quite
different in the terminal on Replit. It was still quite usable, but the colors were different, and the squares of the board were not quite squares. Once I have better control
over the 2D environment in which the game is played, I will come back to this project for improvements.

Update. This game does not display properly on mobile through Replit, though it does display properly through their desktop site. I redid the game board to use ASCII symbols instead
of colored squares for the game board, so that, while looking less impressive, it would be compatible across more platforms. Unfortunately, while running, I noticed that the new
game board was a strain on my eyes. I believe it is infinitly better that a program run well on two platforms rather than poorly on three platforms, so I am deciding to keep it as is.