# hubot-pogocalc

A hubot script to calculate pokemon go IVs from user input

See [`src/pogocalc.coffee`](src/pogocalc.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-pogocalc --save`

Then add **hubot-pogocalc** to your `external-scripts.json`:

```json
[
  "hubot-pogocalc"
]
```

## Sample Interaction

```
user1>> hubot pokemon calculate Growlithe 72 746 2500
hubot>> *STA*​: 11.36 ​*ATK*​: 14.25 ​*DEF*​: 14.25
That's a 88.58% perfect pokemon!

user1>> hubot pokedex golbat weaknesses
hubot>> Electric,Ice,Psychic,Rock

user1>> hubot pokedex golbat
hubot>> Golbat (042)
Poison / Flying
Height: 1.60 m / Weight: 55.0 kg
Evolve Cost: None / hatched from Not in Eggs
Weaknesses: Electric,Ice,Psychic,Rock
Previous evolution: Zubat
```
