chai = require 'chai'
expect = chai.expect
Helper = require('hubot-test-helper');
require ('coffee-script/register');
helper = new Helper('../src/pogocalc.coffee')

describe 'pogocalc', ->
  beforeEach ->
    @room = helper.createRoom()
  afterEach ->
    @room.destroy()

  it 'lists pokemon attributes', ->
    @room.user.say('user', '@hubot pokemon attributes').then =>
      expect(@room.messages).to.eql [
        ['user', '@hubot pokemon attributes']
        ['hubot', 'Pokedex entries have the following attributes: id, num, name, img, type, height, weight, candy, egg, multipliers, weaknesses, next_evolution, prev_evolution'] 
      ]

  it 'can calculate evolved pokemon CP', ->
    @room.user.say('user', '@hubot evolve eevee 523').then =>
      expect(@room.messages).to.eql [
        ['user', '@hubot evolve eevee 523']
        ['hubot', 'Max evolved CP for Eevee is 1381\nMinimum evolved CP for Eevee is 1056']
      ]
  it 'can retrieve specific properties of pokemon', ->
    @room.user.say('user', '@hubot pokedex golbat weaknesses').then =>
      expect(@room.messages).to.eql [
        ['user', '@hubot pokedex golbat weaknesses']
        ['hubot', 'Electric,Ice,Psychic,Rock']
      ]

  it 'can retrieve a pokedex entry by name', ->
    @room.user.say('user', '@hubot pokedex golbat').then =>
      expect(@room.messages).to.eql [
        ['user', '@hubot pokedex golbat']
        ['hubot', 'Golbat (042)\nPoison / Flying\nHeight: 1.60 m / Weight: 55.0 kg\nEvolve Cost: None / hatched from Not in Eggs\nWeaknesses: Electric,Ice,Psychic,Rock\nPrevious evolution: Zubat']
      ]

  it 'can retrieve a pokedex entry by number', ->
    @room.user.say('user', '@hubot pokedex 42').then =>
      expect(@room.messages).to.eql [
        ['user', '@hubot pokedex 42']
        ['hubot', 'Golbat (042)\nPoison / Flying\nHeight: 1.60 m / Weight: 55.0 kg\nEvolve Cost: None / hatched from Not in Eggs\nWeaknesses: Electric,Ice,Psychic,Rock\nPrevious evolution: Zubat']
      ]
