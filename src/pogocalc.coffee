# Description:
#   Provides a way to query the pokemon go pokedex and provide statics and properties of pokemon
#
# Dependencies
#  "Underscore": "^1.8.3"
#
# Commands:
#  hubot pokedex [ID](int) - Prints all information about pokemon with ID [ID]
#  hubot pokedex [PokemonName](string) [PropertyName](string)(?) - Prints information the pokemon with name [PokemonName]. If a [PropertyName] is specified, print only that property.
#  hubot pokemon attributes - Print possible PropertyNames for use in pokedex querying.
#  hubot pokemon calculate [PokemonName](string) [HP](int) [CP](int) [DustPrice](int) - Prints the IV levels and % perfect pokemon based on HP, CP and DustPrice.
#
# Author:
#  SamTwining


#pokedexData = require "pokedex.json"
#pokemon = require "data/pokemon.js"
_ = require "underscore"
#utils = require "util/utils.js"
#pokemonBaseStats = require "pokemonBaseStats.json"

######################################################
# Data
######################################################

levelsByStardust = [
  {
    'stardust': 200
    'level': 1
  }
  {
    'stardust': 400
    'level': 3
  }
  {
    'stardust': 600
    'level': 5
  }
  {
    'stardust': 800
    'level': 7
  }
  {
    'stardust': 1000
    'level': 9
  }
  {
    'stardust': 1300
    'level': 11
  }
  {
    'stardust': 1600
    'level': 13
  }
  {
    'stardust': 1900
    'level': 15
  }
  {
    'stardust': 2200
    'level': 17
  }
  {
    'stardust': 2500
    'level': 19
  }
  {
    'stardust': 3000
    'level': 21
  }
  {
    'stardust': 3500
    'level': 23
  }
  {
    'stardust': 4000
    'level': 25
  }
  {
    'stardust': 4500
    'level': 27
  }
  {
    'stardust': 5000
    'level': 29
  }
  {
    'stardust': 6000
    'level': 31
  }
  {
    'stardust': 7000
    'level': 33
  }
  {
    'stardust': 8000
    'level': 35
  }
  {
    'stardust': 9000
    'level': 37
  }
  {
    'stardust': 10000
    'level': 39
  }
]


cpMultiplierTable = 
  '1': 0.0940000
  '1.5': 0.1351374
  '2': 0.1663979
  '2.5': 0.1926509
  '3': 0.2157325
  '3.5': 0.2365727
  '4': 0.2557201
  '4.5': 0.2735304
  '5': 0.2902499
  '5.5': 0.3060574
  '6': 0.3210876
  '6.5': 0.3354450
  '7': 0.3492127
  '7.5': 0.3624578
  '8': 0.3752356
  '8.5': 0.3875924
  '9': 0.3995673
  '9.5': 0.4111936
  '10': 0.4225000
  '10.5': 0.4335117
  '11': 0.4431076
  '11.5': 0.4530600
  '12': 0.4627984
  '12.5': 0.4723361
  '13': 0.4816850
  '13.5': 0.4908558
  '14': 0.4998584
  '14.5': 0.5087018
  '15': 0.5173940
  '15.5': 0.5259425
  '16': 0.5343543
  '16.5': 0.5426358
  '17': 0.5507927
  '17.5': 0.5588306
  '18': 0.5667545
  '18.5': 0.5745692
  '19': 0.5822789
  '19.5': 0.5898879
  '20': 0.5974000
  '20.5': 0.6048188
  '21': 0.6121573
  '21.5': 0.6194041
  '22': 0.6265671
  '22.5': 0.6336492
  '23': 0.6406530
  '23.5': 0.6475810
  '24': 0.6544356
  '24.5': 0.6612193
  '25': 0.6679340
  '25.5': 0.6745819
  '26': 0.6811649
  '26.5': 0.6876849
  '27': 0.6941437
  '27.5': 0.7005429
  '28': 0.7068842
  '28.5': 0.7131691
  '29': 0.7193991
  '29.5': 0.7255756
  '30': 0.7317000
  '30.5': 0.7377735
  '31': 0.7377695
  '31.5': 0.7407856
  '32': 0.7437894
  '32.5': 0.7467812
  '33': 0.7497610
  '33.5': 0.7527291
  '34': 0.7556855
  '34.5': 0.7586304
  '35': 0.7615638
  '35.5': 0.7644861
  '36': 0.7673972
  '36.5': 0.7702973
  '37': 0.7731865
  '37.5': 0.7760650
  '38': 0.7789328
  '38.5': 0.7817901
  '39': 0.7846370
  '39.5': 0.7874736
  '40': 0.7903000
  '40.5': 0.7931164

pokedexData = [
  {
    'id': 1
    'num': '001'
    'name': 'Bulbasaur'
    'img': 'http://www.serebii.net/pokemongo/pokemon/001.png'
    'type': 'Grass / Poison'
    'height': '0.71 m'
    'weight': '6.9 kg'
    'candy': '25 Bulbasaur Candy'
    'egg': '2 km'
    'multipliers': 1.58
    'weakness': [
      'Fire'
      'Ice'
      'Flying'
      'Psychic'
    ]
    'next_evolution': [
      {
        'num': '002'
        'name': 'Ivysaur'
      }
      {
        'num': '003'
        'name': 'Venusaur'
      }
    ]
  }
  {
    'id': 2
    'num': '002'
    'name': 'Ivysaur'
    'img': 'http://www.serebii.net/pokemongo/pokemon/002.png'
    'type': 'Grass / Poison'
    'height': '0.99 m'
    'weight': '13.0 kg'
    'candy': '100 Bulbasaur Candy'
    'egg': 'Not in Eggs'
    'multipliers': [
      1.2
      1.6
    ]
    'weaknesses': [
      'Fire'
      'Ice'
      'Flying'
      'Psychic'
    ]
    'prev_evolution': [ {
      'num': '001'
      'name': 'Bulbasaur'
    } ]
    'next_evolution': [ {
      'num': '003'
      'name': 'Venusaur'
    } ]
  }
  {
    'id': 3
    'num': '003'
    'name': 'Venusaur'
    'img': 'http://www.serebii.net/pokemongo/pokemon/003.png'
    'type': 'Grass / Poison'
    'height': '2.01 m'
    'weight': '100.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Fire'
      'Ice'
      'Flying'
      'Psychic'
    ]
    'prev_evolution': [
      {
        'num': '001'
        'name': 'Bulbasaur'
      }
      {
        'num': '002'
        'name': 'Ivysaur'
      }
    ]
  }
  {
    'id': 4
    'num': '004'
    'name': 'Charmander'
    'img': 'http://www.serebii.net/pokemongo/pokemon/004.png'
    'type': 'Fire'
    'height': '0.61 m'
    'weight': '8.5 kg'
    'candy': '25 Charmander Candy'
    'egg': '2 km'
    'multipliers': 1.65
    'weaknesses': [
      'Water'
      'Ground'
      'Rock'
    ]
    'next_evolution': [
      {
        'num': '005'
        'name': 'Charmeleon'
      }
      {
        'num': '006'
        'name': 'Charizard'
      }
    ]
  }
  {
    'id': 5
    'num': '005'
    'name': 'Charmeleon'
    'img': 'http://www.serebii.net/pokemongo/pokemon/005.png'
    'type': 'Fire'
    'height': '1.09 m'
    'weight': '19.0 kg'
    'candy': '100 Charmander Candy'
    'egg': 'Not in Eggs'
    'multipliers': 1.79
    'weaknesses': [
      'Water'
      'Ground'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '004'
      'name': 'Charmander'
    } ]
    'next_evolution': [ {
      'num': '006'
      'name': 'Charizard'
    } ]
  }
  {
    'id': 6
    'num': '006'
    'name': 'Charizard'
    'img': 'http://www.serebii.net/pokemongo/pokemon/006.png'
    'type': 'Fire / Flying'
    'height': '1.70 m'
    'weight': '90.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Electric'
      'Rock'
    ]
    'prev_evolution': [
      {
        'num': '004'
        'name': 'Charmander'
      }
      {
        'num': '005'
        'name': 'Charmeleon'
      }
    ]
  }
  {
    'id': 7
    'num': '007'
    'name': 'Squirtle'
    'img': 'http://www.serebii.net/pokemongo/pokemon/007.png'
    'type': 'Water'
    'height': '0.51 m'
    'weight': '9.0 kg'
    'candy': '25 Squirtle Candy'
    'egg': '2 km'
    'multipliers': 2.1
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'next_evolution': [
      {
        'num': '008'
        'name': 'Wartortle'
      }
      {
        'num': '009'
        'name': 'Blastoise'
      }
    ]
  }
  {
    'id': 8
    'num': '008'
    'name': 'Wartortle'
    'img': 'http://www.serebii.net/pokemongo/pokemon/008.png'
    'type': 'Water'
    'height': '0.99 m'
    'weight': '22.5 kg'
    'candy': '100 Squirtle Candy'
    'egg': 'Not in Eggs'
    'multipliers': 1.4
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'prev_evolution': [ {
      'num': '007'
      'name': 'Squirtle'
    } ]
    'next_evolution': [ {
      'num': '009'
      'name': 'Blastoise'
    } ]
  }
  {
    'id': 9
    'num': '009'
    'name': 'Blastoise'
    'img': 'http://www.serebii.net/pokemongo/pokemon/009.png'
    'type': 'Water'
    'height': '1.60 m'
    'weight': '85.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'prev_evolution': [
      {
        'num': '007'
        'name': 'Squirtle'
      }
      {
        'num': '008'
        'name': 'Wartortle'
      }
    ]
  }
  {
    'id': 10
    'num': '010'
    'name': 'Caterpie'
    'img': 'http://www.serebii.net/pokemongo/pokemon/010.png'
    'type': 'Bug'
    'height': '0.30 m'
    'weight': '2.9 kg'
    'candy': '12 Caterpie Candy'
    'egg': '2 km'
    'multipliers': 1.05
    'weaknesses': [
      'Fire'
      'Flying'
      'Rock'
    ]
    'next_evolution': [
      {
        'num': '011'
        'name': 'Metapod'
      }
      {
        'num': '012'
        'name': 'Butterfree'
      }
    ]
  }
  {
    'id': 11
    'num': '011'
    'name': 'Metapod'
    'img': 'http://www.serebii.net/pokemongo/pokemon/011.png'
    'type': 'Bug'
    'height': '0.71 m'
    'weight': '9.9 kg'
    'candy': '50 Caterpie Candy'
    'egg': 'Not in Eggs'
    'multipliers': [
      3.55
      3.79
    ]
    'weaknesses': [
      'Fire'
      'Flying'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '010'
      'name': 'Caterpie'
    } ]
    'next_evolution': [ {
      'num': '012'
      'name': 'Butterfree'
    } ]
  }
  {
    'id': 12
    'num': '012'
    'name': 'Butterfree'
    'img': 'http://www.serebii.net/pokemongo/pokemon/012.png'
    'type': 'Bug / Flying'
    'height': '1.09 m'
    'weight': '32.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Fire'
      'Electric'
      'Ice'
      'Flying'
      'Rock'
    ]
    'prev_evolution': [
      {
        'num': '010'
        'name': 'Caterpie'
      }
      {
        'num': '011'
        'name': 'Metapod'
      }
    ]
  }
  {
    'id': 13
    'num': '013'
    'name': 'Weedle'
    'img': 'http://www.serebii.net/pokemongo/pokemon/013.png'
    'type': 'Bug / Poison'
    'height': '0.30 m'
    'weight': '3.2 kg'
    'candy': '12 Weedle Candy'
    'egg': '2 km'
    'multipliers': [
      1.01
      1.09
    ]
    'weaknesses': [
      'Fire'
      'Flying'
      'Psychic'
      'Rock'
    ]
    'next_evolution': [
      {
        'num': '014'
        'name': 'Kakuna'
      }
      {
        'num': '015'
        'name': 'Beedrill'
      }
    ]
  }
  {
    'id': 14
    'num': '014'
    'name': 'Kakuna'
    'img': 'http://www.serebii.net/pokemongo/pokemon/014.png'
    'type': 'Bug / Poison'
    'height': '0.61 m'
    'weight': '10.0 kg'
    'candy': '50 Weedle Candy'
    'egg': 'Not in Eggs'
    'multipliers': [
      3.01
      3.41
    ]
    'weaknesses': [
      'Fire'
      'Flying'
      'Psychic'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '013'
      'name': 'Weedle'
    } ]
    'next_evolution': [ {
      'num': '015'
      'name': 'Beedrill'
    } ]
  }
  {
    'id': 15
    'num': '015'
    'name': 'Beedrill'
    'img': 'http://www.serebii.net/pokemongo/pokemon/015.png'
    'type': 'Bug / Poison'
    'height': '0.99 m'
    'weight': '29.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Fire'
      'Flying'
      'Psychic'
      'Rock'
    ]
    'prev_evolution': [
      {
        'num': '013'
        'name': 'Weedle'
      }
      {
        'num': '014'
        'name': 'Kakuna'
      }
    ]
  }
  {
    'id': 16
    'num': '016'
    'name': 'Pidgey'
    'img': 'http://www.serebii.net/pokemongo/pokemon/016.png'
    'type': 'Normal / Flying'
    'height': '0.30 m'
    'weight': '1.8 kg'
    'candy': '12 Pidgey Candy'
    'egg': '2 km'
    'multipliers': [
      1.71
      1.92
    ]
    'weaknesses': [
      'Electric'
      'Rock'
    ]
    'next_evolution': [
      {
        'num': '017'
        'name': 'Pidgeotto'
      }
      {
        'num': '018'
        'name': 'Pidgeot'
      }
    ]
  }
  {
    'id': 17
    'num': '017'
    'name': 'Pidgeotto'
    'img': 'http://www.serebii.net/pokemongo/pokemon/017.png'
    'type': 'Normal / Flying'
    'height': '1.09 m'
    'weight': '30.0 kg'
    'candy': '50 Pidgey Candy'
    'egg': 'Not in Eggs'
    'multipliers': 1.79
    'weaknesses': [
      'Electric'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '016'
      'name': 'Pidgey'
    } ]
    'next_evolution': [ {
      'num': '018'
      'name': 'Pidgeot'
    } ]
  }
  {
    'id': 18
    'num': '018'
    'name': 'Pidgeot'
    'img': 'http://www.serebii.net/pokemongo/pokemon/018.png'
    'type': 'Normal / Flying'
    'height': '1.50 m'
    'weight': '39.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Rock'
    ]
    'prev_evolution': [
      {
        'num': '016'
        'name': 'Pidgey'
      }
      {
        'num': '017'
        'name': 'Pidgeotto'
      }
    ]
  }
  {
    'id': 19
    'num': '019'
    'name': 'Rattata'
    'img': 'http://www.serebii.net/pokemongo/pokemon/019.png'
    'type': 'Normal'
    'height': '0.30 m'
    'weight': '3.5 kg'
    'candy': '25 Rattata Candy'
    'egg': '2 km'
    'multipliers': [
      2.55
      2.73
    ]
    'weaknesses': [ 'Fighting' ]
    'next_evolution': [ {
      'num': '020'
      'name': 'Raticate'
    } ]
  }
  {
    'id': 20
    'num': '020'
    'name': 'Raticate'
    'img': 'http://www.serebii.net/pokemongo/pokemon/020.png'
    'type': 'Normal'
    'height': '0.71 m'
    'weight': '18.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [ 'Fighting' ]
    'prev_evolution': [ {
      'num': '019'
      'name': 'Rattata'
    } ]
  }
  {
    'id': 21
    'num': '021'
    'name': 'Spearow'
    'img': 'http://www.serebii.net/pokemongo/pokemon/021.png'
    'type': 'Normal / Flying'
    'height': '0.30 m'
    'weight': '2.0 kg'
    'candy': '50 Spearow Candy'
    'egg': '2 km'
    'multipliers': [
      2.66
      2.68
    ]
    'weaknesses': [
      'Electric'
      'Rock'
    ]
    'next_evolution': [ {
      'num': '022'
      'name': 'Fearow'
    } ]
  }
  {
    'id': 22
    'num': '022'
    'name': 'Fearow'
    'img': 'http://www.serebii.net/pokemongo/pokemon/022.png'
    'type': 'Normal / Flying'
    'height': '1.19 m'
    'weight': '38.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '021'
      'name': 'Spearow'
    } ]
  }
  {
    'id': 23
    'num': '023'
    'name': 'Ekans'
    'img': 'http://www.serebii.net/pokemongo/pokemon/023.png'
    'type': 'Poison'
    'height': '2.01 m'
    'weight': '6.9 kg'
    'candy': '50 Ekans Candy'
    'egg': '5 km'
    'multipliers': [
      2.21
      2.27
    ]
    'weaknesses': [
      'Ground'
      'Psychic'
    ]
    'next_evolution': [ {
      'num': '024'
      'name': 'Arbok'
    } ]
  }
  {
    'id': 24
    'num': '024'
    'name': 'Arbok'
    'img': 'http://www.serebii.net/pokemongo/pokemon/024.png'
    'type': 'Poison'
    'height': '3.51 m'
    'weight': '65.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Ground'
      'Psychic'
    ]
    'prev_evolution': [ {
      'num': '023'
      'name': 'Ekans'
    } ]
  }
  {
    'id': 25
    'num': '025'
    'name': 'Pikachu'
    'img': 'http://www.serebii.net/pokemongo/pokemon/025.png'
    'type': 'Electric'
    'height': '0.41 m'
    'weight': '6.0 kg'
    'candy': '50 Pikachu Candy'
    'egg': '2 km'
    'multipliers': 2.34
    'weaknesses': [ 'Ground' ]
    'next_evolution': [ {
      'num': '026'
      'name': 'Raichu'
    } ]
  }
  {
    'id': 26
    'num': '026'
    'name': 'Raichu'
    'img': 'http://www.serebii.net/pokemongo/pokemon/026.png'
    'type': 'Electric'
    'height': '0.79 m'
    'weight': '30.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [ 'Ground' ]
    'prev_evolution': [ {
      'num': '025'
      'name': 'Pikachu'
    } ]
  }
  {
    'id': 27
    'num': '027'
    'name': 'Sandshrew'
    'img': 'http://www.serebii.net/pokemongo/pokemon/027.png'
    'type': 'Ground'
    'height': '0.61 m'
    'weight': '12.0 kg'
    'candy': '50 Sandshrew Candy'
    'egg': '5 km'
    'multipliers': 2.45
    'weaknesses': [
      'Water'
      'Grass'
      'Ice'
    ]
    'next_evolution': [ {
      'num': '028'
      'name': 'Sandslash'
    } ]
  }
  {
    'id': 28
    'num': '028'
    'name': 'Sandslash'
    'img': 'http://www.serebii.net/pokemongo/pokemon/028.png'
    'type': 'Ground'
    'height': '0.99 m'
    'weight': '29.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Grass'
      'Ice'
    ]
    'prev_evolution': [ {
      'num': '027'
      'name': 'Sandshrew'
    } ]
  }
  {
    'id': 29
    'num': '029'
    'name': 'Nidoran ♀ (Female)'
    'img': 'http://www.serebii.net/pokemongo/pokemon/029.png'
    'type': 'Poison'
    'height': '0.41 m'
    'weight': '7.0 kg'
    'candy': '25 Nidoran ♀ (Female) Candy'
    'egg': '5 km'
    'multipliers': [
      1.63
      2.48
    ]
    'weaknesses': [
      'Ground'
      'Psychic'
    ]
    'next_evolution': [
      {
        'num': '030'
        'name': 'Nidorina'
      }
      {
        'num': '031'
        'name': 'Nidoqueen'
      }
    ]
  }
  {
    'id': 30
    'num': '030'
    'name': 'Nidorina'
    'img': 'http://www.serebii.net/pokemongo/pokemon/030.png'
    'type': 'Poison'
    'height': '0.79 m'
    'weight': '20.0 kg'
    'candy': '100 Nidoran ♀ Candy'
    'egg': 'Not in Eggs'
    'multipliers': [
      1.83
      2.48
    ]
    'weaknesses': [
      'Ground'
      'Psychic'
    ]
    'prev_evolution': [ {
      'num': '029'
      'name': 'Nidoran(Female)'
    } ]
    'next_evolution': [ {
      'num': '031'
      'name': 'Nidoqueen'
    } ]
  }
  {
    'id': 31
    'num': '031'
    'name': 'Nidoqueen'
    'img': 'http://www.serebii.net/pokemongo/pokemon/031.png'
    'type': 'Poison / Ground'
    'height': '1.30 m'
    'weight': '60.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Ice'
      'Ground'
      'Psychic'
    ]
    'prev_evolution': [
      {
        'num': '029'
        'name': 'Nidoran(Female)'
      }
      {
        'num': '030'
        'name': 'Nidorina'
      }
    ]
  }
  {
    'id': 32
    'num': '032'
    'name': 'Nidoran ♂ (Male)'
    'img': 'http://www.serebii.net/pokemongo/pokemon/032.png'
    'type': 'Poison'
    'height': '0.51 m'
    'weight': '9.0 kg'
    'candy': '25 Nidoran ♂ (Male) Candy'
    'egg': '5 km'
    'multipliers': [
      1.64
      1.7
    ]
    'weaknesses': [
      'Ground'
      'Psychic'
    ]
    'next_evolution': [
      {
        'num': '033'
        'name': 'Nidorino'
      }
      {
        'num': '034'
        'name': 'Nidoking'
      }
    ]
  }
  {
    'id': 33
    'num': '033'
    'name': 'Nidorino'
    'img': 'http://www.serebii.net/pokemongo/pokemon/033.png'
    'type': 'Poison'
    'height': '0.89 m'
    'weight': '19.5 kg'
    'candy': '100 Nidoran ♂ Candy'
    'egg': 'Not in Eggs'
    'multipliers': 1.83
    'weaknesses': [
      'Ground'
      'Psychic'
    ]
    'prev_evolution': [ {
      'num': '032'
      'name': 'Nidoran(Male)'
    } ]
    'next_evolution': [ {
      'num': '034'
      'name': 'Nidoking'
    } ]
  }
  {
    'id': 34
    'num': '034'
    'name': 'Nidoking'
    'img': 'http://www.serebii.net/pokemongo/pokemon/034.png'
    'type': 'Poison / Ground'
    'height': '1.40 m'
    'weight': '62.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Ice'
      'Ground'
      'Psychic'
    ]
    'prev_evolution': [
      {
        'num': '032'
        'name': 'Nidoran(Male)'
      }
      {
        'num': '033'
        'name': 'Nidorino'
      }
    ]
  }
  {
    'id': 35
    'num': '035'
    'name': 'Clefairy'
    'img': 'http://www.serebii.net/pokemongo/pokemon/035.png'
    'type': 'Normal'
    'height': '0.61 m'
    'weight': '7.5 kg'
    'candy': '50 Clefairy Candy'
    'egg': '2 km'
    'multipliers': [
      2.03
      2.14
    ]
    'weaknesses': [ 'Fighting' ]
    'next_evolution': [ {
      'num': '036'
      'name': 'Clefable'
    } ]
  }
  {
    'id': 36
    'num': '036'
    'name': 'Clefable'
    'img': 'http://www.serebii.net/pokemongo/pokemon/036.png'
    'type': 'Normal'
    'height': '1.30 m'
    'weight': '40.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [ 'Fighting' ]
    'prev_evolution': [ {
      'num': '035'
      'name': 'Clefairy'
    } ]
  }
  {
    'id': 37
    'num': '037'
    'name': 'Vulpix'
    'img': 'http://www.serebii.net/pokemongo/pokemon/037.png'
    'type': 'Fire'
    'height': '0.61 m'
    'weight': '9.9 kg'
    'candy': '50 Vulpix Candy'
    'egg': '5 km'
    'multipliers': [
      2.74
      2.81
    ]
    'weaknesses': [
      'Water'
      'Ground'
      'Rock'
    ]
    'next_evolution': [ {
      'num': '038'
      'name': 'Ninetales'
    } ]
  }
  {
    'id': 38
    'num': '038'
    'name': 'Ninetales'
    'img': 'http://www.serebii.net/pokemongo/pokemon/038.png'
    'type': 'Fire'
    'height': '1.09 m'
    'weight': '19.9 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Ground'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '037'
      'name': 'Vulpix'
    } ]
  }
  {
    'id': 39
    'num': '039'
    'name': 'Jigglypuff'
    'img': 'http://www.serebii.net/pokemongo/pokemon/039.png'
    'type': 'Normal'
    'height': '0.51 m'
    'weight': '5.5 kg'
    'candy': '50 Jigglypuff Candy'
    'egg': '2 km'
    'multipliers': 1.85
    'weaknesses': [ 'Fighting' ]
    'next_evolution': [ {
      'num': '040'
      'name': 'Wigglytuff'
    } ]
  }
  {
    'id': 40
    'num': '040'
    'name': 'Wigglytuff'
    'img': 'http://www.serebii.net/pokemongo/pokemon/040.png'
    'type': 'Normal'
    'height': '0.99 m'
    'weight': '12.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [ 'Fighting' ]
    'prev_evolution': [ {
      'num': '039'
      'name': 'Jigglypuff'
    } ]
  }
  {
    'id': 41
    'num': '041'
    'name': 'Zubat'
    'img': 'http://www.serebii.net/pokemongo/pokemon/041.png'
    'type': 'Poison / Flying'
    'height': '0.79 m'
    'weight': '7.5 kg'
    'candy': '50 Zubat Candy'
    'egg': '2 km'
    'multipliers': [
      2.6
      3.67
    ]
    'weaknesses': [
      'Electric'
      'Ice'
      'Psychic'
      'Rock'
    ]
    'next_evolution': [ {
      'num': '042'
      'name': 'Golbat'
    } ]
  }
  {
    'id': 42
    'num': '042'
    'name': 'Golbat'
    'img': 'http://www.serebii.net/pokemongo/pokemon/042.png'
    'type': 'Poison / Flying'
    'height': '1.60 m'
    'weight': '55.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Ice'
      'Psychic'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '041'
      'name': 'Zubat'
    } ]
  }
  {
    'id': 43
    'num': '043'
    'name': 'Oddish'
    'img': 'http://www.serebii.net/pokemongo/pokemon/043.png'
    'type': 'Grass / Poison'
    'height': '0.51 m'
    'weight': '5.4 kg'
    'candy': '25 Oddish Candy'
    'egg': '5 km'
    'multipliers': 1.5
    'weaknesses': [
      'Fire'
      'Ice'
      'Flying'
      'Psychic'
    ]
    'next_evolution': [
      {
        'num': '044'
        'name': 'Gloom'
      }
      {
        'num': '045'
        'name': 'Vileplume'
      }
    ]
  }
  {
    'id': 44
    'num': '044'
    'name': 'Gloom'
    'img': 'http://www.serebii.net/pokemongo/pokemon/044.png'
    'type': 'Grass / Poison'
    'height': '0.79 m'
    'weight': '8.6 kg'
    'candy': '100 Oddish Candy'
    'egg': 'Not in Eggs'
    'multipliers': 1.49
    'weaknesses': [
      'Fire'
      'Ice'
      'Flying'
      'Psychic'
    ]
    'prev_evolution': [ {
      'num': '043'
      'name': 'Oddish'
    } ]
    'next_evolution': [ {
      'num': '045'
      'name': 'Vileplume'
    } ]
  }
  {
    'id': 45
    'num': '045'
    'name': 'Vileplume'
    'img': 'http://www.serebii.net/pokemongo/pokemon/045.png'
    'type': 'Grass / Poison'
    'height': '1.19 m'
    'weight': '18.6 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Fire'
      'Ice'
      'Flying'
      'Psychic'
    ]
    'prev_evolution': [
      {
        'num': '043'
        'name': 'Oddish'
      }
      {
        'num': '044'
        'name': 'Gloom'
      }
    ]
  }
  {
    'id': 46
    'num': '046'
    'name': 'Paras'
    'img': 'http://www.serebii.net/pokemongo/pokemon/046.png'
    'type': 'Bug / Grass'
    'height': '0.30 m'
    'weight': '5.4 kg'
    'candy': '50 Paras Candy'
    'egg': '5 km'
    'multipliers': 2.02
    'weaknesses': [
      'Fire'
      'Ice'
      'Poison'
      'Flying'
      'Bug'
      'Rock'
    ]
    'next_evolution': [ {
      'num': '047'
      'name': 'Parasect'
    } ]
  }
  {
    'id': 47
    'num': '047'
    'name': 'Parasect'
    'img': 'http://www.serebii.net/pokemongo/pokemon/047.png'
    'type': 'Bug / Grass'
    'height': '0.99 m'
    'weight': '29.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Fire'
      'Ice'
      'Poison'
      'Flying'
      'Bug'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '046'
      'name': 'Paras'
    } ]
  }
  {
    'id': 48
    'num': '048'
    'name': 'Venonat'
    'img': 'http://www.serebii.net/pokemongo/pokemon/048.png'
    'type': 'Bug / Poison'
    'height': '0.99 m'
    'weight': '30.0 kg'
    'candy': '50 Venonat Candy'
    'egg': '5 km'
    'multipliers': [
      1.86
      1.9
    ]
    'weaknesses': [
      'Fire'
      'Flying'
      'Psychic'
      'Rock'
    ]
    'next_evolution': [ {
      'num': '049'
      'name': 'Venomoth'
    } ]
  }
  {
    'id': 49
    'num': '049'
    'name': 'Venomoth'
    'img': 'http://www.serebii.net/pokemongo/pokemon/049.png'
    'type': 'Bug / Poison'
    'height': '1.50 m'
    'weight': '12.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Fire'
      'Flying'
      'Psychic'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '048'
      'name': 'Venonat'
    } ]
  }
  {
    'id': 50
    'num': '050'
    'name': 'Diglett'
    'img': 'http://www.serebii.net/pokemongo/pokemon/050.png'
    'type': 'Ground'
    'height': '0.20 m'
    'weight': '0.8 kg'
    'candy': '50 Diglett Candy'
    'egg': '5 km'
    'multipliers': 2.69
    'weaknesses': [
      'Water'
      'Grass'
      'Ice'
    ]
    'next_evolution': [ {
      'num': '051'
      'name': 'Dugtrio'
    } ]
  }
  {
    'id': 51
    'num': '051'
    'name': 'Dugtrio'
    'img': 'http://www.serebii.net/pokemongo/pokemon/051.png'
    'type': 'Ground'
    'height': '0.71 m'
    'weight': '33.3 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Grass'
      'Ice'
    ]
    'prev_evolution': [ {
      'num': '050'
      'name': 'Diglett'
    } ]
  }
  {
    'id': 52
    'num': '052'
    'name': 'Meowth'
    'img': 'http://www.serebii.net/pokemongo/pokemon/052.png'
    'type': 'Normal'
    'height': '0.41 m'
    'weight': '4.2 kg'
    'candy': '50 Meowth Candy'
    'egg': '5 km'
    'multipliers': 1.98
    'weaknesses': [ 'Fighting' ]
    'next_evolution': [ {
      'num': '053'
      'name': 'Persian'
    } ]
  }
  {
    'id': 53
    'num': '053'
    'name': 'Persian'
    'img': 'http://www.serebii.net/pokemongo/pokemon/053.png'
    'type': 'Normal'
    'height': '0.99 m'
    'weight': '32.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [ 'Fighting' ]
    'prev_evolution': [ {
      'num': '052'
      'name': 'Meowth'
    } ]
  }
  {
    'id': 54
    'num': '054'
    'name': 'Psyduck'
    'img': 'http://www.serebii.net/pokemongo/pokemon/054.png'
    'type': 'Water'
    'height': '0.79 m'
    'weight': '19.6 kg'
    'candy': '50 Psyduck Candy'
    'egg': '5 km'
    'multipliers': 2.27
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'next_evolution': [ {
      'num': '055'
      'name': 'Golduck'
    } ]
  }
  {
    'id': 55
    'num': '055'
    'name': 'Golduck'
    'img': 'http://www.serebii.net/pokemongo/pokemon/055.png'
    'type': 'Water'
    'height': '1.70 m'
    'weight': '76.6 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'prev_evolution': [ {
      'num': '054'
      'name': 'Psyduck'
    } ]
  }
  {
    'id': 56
    'num': '056'
    'name': 'Mankey'
    'img': 'http://www.serebii.net/pokemongo/pokemon/056.png'
    'type': 'Fighting'
    'height': '0.51 m'
    'weight': '28.0 kg'
    'candy': '50 Mankey Candy'
    'egg': '5 km'
    'multipliers': [
      2.17
      2.28
    ]
    'weaknesses': [
      'Flying'
      'Psychic'
      'Fairy'
    ]
    'next_evolution': [ {
      'num': '057'
      'name': 'Primeape'
    } ]
  }
  {
    'id': 57
    'num': '057'
    'name': 'Primeape'
    'img': 'http://www.serebii.net/pokemongo/pokemon/057.png'
    'type': 'Fighting'
    'height': '0.99 m'
    'weight': '32.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Flying'
      'Psychic'
      'Fairy'
    ]
    'prev_evolution': [ {
      'num': '056'
      'name': 'Mankey'
    } ]
  }
  {
    'id': 58
    'num': '058'
    'name': 'Growlithe'
    'img': 'http://www.serebii.net/pokemongo/pokemon/058.png'
    'type': 'Fire'
    'height': '0.71 m'
    'weight': '19.0 kg'
    'candy': '50 Growlithe Candy'
    'egg': '5 km'
    'multipliers': [
      2.31
      2.36
    ]
    'weaknesses': [
      'Water'
      'Ground'
      'Rock'
    ]
    'next_evolution': [ {
      'num': '059'
      'name': 'Arcanine'
    } ]
  }
  {
    'id': 59
    'num': '059'
    'name': 'Arcanine'
    'img': 'http://www.serebii.net/pokemongo/pokemon/059.png'
    'type': 'Fire'
    'height': '1.91 m'
    'weight': '155.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Ground'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '058'
      'name': 'Growlithe'
    } ]
  }
  {
    'id': 60
    'num': '060'
    'name': 'Poliwag'
    'img': 'http://www.serebii.net/pokemongo/pokemon/060.png'
    'type': 'Water'
    'height': '0.61 m'
    'weight': '12.4 kg'
    'candy': '25 Poliwag Candy'
    'egg': '5 km'
    'multipliers': [
      1.72
      1.73
    ]
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'next_evolution': [
      {
        'num': '061'
        'name': 'Poliwhirl'
      }
      {
        'num': '062'
        'name': 'Poliwrath'
      }
    ]
  }
  {
    'id': 61
    'num': '061'
    'name': 'Poliwhirl'
    'img': 'http://www.serebii.net/pokemongo/pokemon/061.png'
    'type': 'Water'
    'height': '0.99 m'
    'weight': '20.0 kg'
    'candy': '100 Poliwag Candy'
    'egg': 'Not in Eggs'
    'multipliers': 1.95
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'prev_evolution': [ {
      'num': '060'
      'name': 'Poliwag'
    } ]
    'next_evolution': [ {
      'num': '062'
      'name': 'Poliwrath'
    } ]
  }
  {
    'id': 62
    'num': '062'
    'name': 'Poliwrath'
    'img': 'http://www.serebii.net/pokemongo/pokemon/062.png'
    'type': 'Water / Fighting'
    'height': '1.30 m'
    'weight': '54.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Grass'
      'Flying'
      'Psychic'
      'Fairy'
    ]
    'prev_evolution': [
      {
        'num': '060'
        'name': 'Poliwag'
      }
      {
        'num': '061'
        'name': 'Poliwhirl'
      }
    ]
  }
  {
    'id': 63
    'num': '063'
    'name': 'Abra'
    'img': 'http://www.serebii.net/pokemongo/pokemon/063.png'
    'type': 'Psychic'
    'height': '0.89 m'
    'weight': '19.5 kg'
    'candy': '25 Abra Candy'
    'egg': '5 km'
    'multipliers': [
      1.36
      1.95
    ]
    'weaknesses': [
      'Bug'
      'Ghost'
      'Dark'
    ]
    'next_evolution': [
      {
        'num': '064'
        'name': 'Kadabra'
      }
      {
        'num': '065'
        'name': 'Alakazam'
      }
    ]
  }
  {
    'id': 64
    'num': '064'
    'name': 'Kadabra'
    'img': 'http://www.serebii.net/pokemongo/pokemon/064.png'
    'type': 'Psychic'
    'height': '1.30 m'
    'weight': '56.5 kg'
    'candy': '100 Abra Candy'
    'egg': 'Not in Eggs'
    'multipliers': 1.4
    'weaknesses': [
      'Bug'
      'Ghost'
      'Dark'
    ]
    'prev_evolution': [ {
      'num': '063'
      'name': 'Abra'
    } ]
    'next_evolution': [ {
      'num': '065'
      'name': 'Alakazam'
    } ]
  }
  {
    'id': 65
    'num': '065'
    'name': 'Alakazam'
    'img': 'http://www.serebii.net/pokemongo/pokemon/065.png'
    'type': 'Psychic'
    'height': '1.50 m'
    'weight': '48.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Bug'
      'Ghost'
      'Dark'
    ]
    'prev_evolution': [
      {
        'num': '063'
        'name': 'Abra'
      }
      {
        'num': '064'
        'name': 'Kadabra'
      }
    ]
  }
  {
    'id': 66
    'num': '066'
    'name': 'Machop'
    'img': 'http://www.serebii.net/pokemongo/pokemon/066.png'
    'type': 'Fighting'
    'height': '0.79 m'
    'weight': '19.5 kg'
    'candy': '25 Machop Candy'
    'egg': '5 km'
    'multipliers': [
      1.64
      1.65
    ]
    'weaknesses': [
      'Flying'
      'Psychic'
      'Fairy'
    ]
    'next_evolution': [
      {
        'num': '067'
        'name': 'Machoke'
      }
      {
        'num': '068'
        'name': 'Machamp'
      }
    ]
  }
  {
    'id': 67
    'num': '067'
    'name': 'Machoke'
    'img': 'http://www.serebii.net/pokemongo/pokemon/067.png'
    'type': 'Fighting'
    'height': '1.50 m'
    'weight': '70.5 kg'
    'candy': '100 Machop Candy'
    'egg': 'Not in Eggs'
    'multipliers': 1.7
    'weaknesses': [
      'Flying'
      'Psychic'
      'Fairy'
    ]
    'prev_evolution': [ {
      'num': '066'
      'name': 'Machop'
    } ]
    'next_evolution': [ {
      'num': '068'
      'name': 'Machamp'
    } ]
  }
  {
    'id': 68
    'num': '068'
    'name': 'Machamp'
    'img': 'http://www.serebii.net/pokemongo/pokemon/068.png'
    'type': 'Fighting'
    'height': '1.60 m'
    'weight': '130.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Flying'
      'Psychic'
      'Fairy'
    ]
    'prev_evolution': [
      {
        'num': '066'
        'name': 'Machop'
      }
      {
        'num': '067'
        'name': 'Machoke'
      }
    ]
  }
  {
    'id': 69
    'num': '069'
    'name': 'Bellsprout'
    'img': 'http://www.serebii.net/pokemongo/pokemon/069.png'
    'type': 'Grass / Poison'
    'height': '0.71 m'
    'weight': '4.0 kg'
    'candy': '25 Bellsprout Candy'
    'egg': '5 km'
    'multipliers': 1.57
    'weaknesses': [
      'Fire'
      'Ice'
      'Flying'
      'Psychic'
    ]
    'next_evolution': [
      {
        'num': '070'
        'name': 'Weepinbell'
      }
      {
        'num': '071'
        'name': 'Victreebel'
      }
    ]
  }
  {
    'id': 70
    'num': '070'
    'name': 'Weepinbell'
    'img': 'http://www.serebii.net/pokemongo/pokemon/070.png'
    'type': 'Grass / Poison'
    'height': '0.99 m'
    'weight': '6.4 kg'
    'candy': '100 Bellsprout Candy'
    'egg': 'Not in Eggs'
    'multipliers': 1.59
    'weaknesses': [
      'Fire'
      'Ice'
      'Flying'
      'Psychic'
    ]
    'prev_evolution': [ {
      'num': '069'
      'name': 'Bellsprout'
    } ]
    'next_evolution': [ {
      'num': '071'
      'name': 'Victreebel'
    } ]
  }
  {
    'id': 71
    'num': '071'
    'name': 'Victreebel'
    'img': 'http://www.serebii.net/pokemongo/pokemon/071.png'
    'type': 'Grass / Poison'
    'height': '1.70 m'
    'weight': '15.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Fire'
      'Ice'
      'Flying'
      'Psychic'
    ]
    'prev_evolution': [
      {
        'num': '069'
        'name': 'Bellsprout'
      }
      {
        'num': '070'
        'name': 'Weepinbell'
      }
    ]
  }
  {
    'id': 72
    'num': '072'
    'name': 'Tentacool'
    'img': 'http://www.serebii.net/pokemongo/pokemon/072.png'
    'type': 'Water / Poison'
    'height': '0.89 m'
    'weight': '45.5 kg'
    'candy': '50 Tentacool Candy'
    'egg': '5 km'
    'multipliers': 2.52
    'weaknesses': [
      'Electric'
      'Ground'
      'Psychic'
    ]
    'next_evolution': [ {
      'num': '073'
      'name': 'Tentacruel'
    } ]
  }
  {
    'id': 73
    'num': '073'
    'name': 'Tentacruel'
    'img': 'http://www.serebii.net/pokemongo/pokemon/073.png'
    'type': 'Water / Poison'
    'height': '1.60 m'
    'weight': '55.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Ground'
      'Psychic'
    ]
    'prev_evolution': [ {
      'num': '072'
      'name': 'Tentacool'
    } ]
  }
  {
    'id': 74
    'num': '074'
    'name': 'Geodude'
    'img': 'http://www.serebii.net/pokemongo/pokemon/074.png'
    'type': 'Rock / Ground'
    'height': '0.41 m'
    'weight': '20.0 kg'
    'candy': '25 Geodude Candy'
    'egg': '2 km'
    'multipliers': [
      1.75
      1.76
    ]
    'weaknesses': [
      'Water'
      'Grass'
      'Ice'
      'Fighting'
      'Ground'
      'Steel'
    ]
    'next_evolution': [
      {
        'num': '075'
        'name': 'Graveler'
      }
      {
        'num': '076'
        'name': 'Golem'
      }
    ]
  }
  {
    'id': 75
    'num': '075'
    'name': 'Graveler'
    'img': 'http://www.serebii.net/pokemongo/pokemon/075.png'
    'type': 'Rock / Ground'
    'height': '0.99 m'
    'weight': '105.0 kg'
    'candy': '100 Geodude Candy'
    'egg': 'Not in Eggs'
    'multipliers': [
      1.64
      1.72
    ]
    'weaknesses': [
      'Water'
      'Grass'
      'Ice'
      'Fighting'
      'Ground'
      'Steel'
    ]
    'prev_evolution': [ {
      'num': '074'
      'name': 'Geodude'
    } ]
    'next_evolution': [ {
      'num': '076'
      'name': 'Golem'
    } ]
  }
  {
    'id': 76
    'num': '076'
    'name': 'Golem'
    'img': 'http://www.serebii.net/pokemongo/pokemon/076.png'
    'type': 'Rock / Ground'
    'height': '1.40 m'
    'weight': '300.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Grass'
      'Ice'
      'Fighting'
      'Ground'
      'Steel'
    ]
    'prev_evolution': [
      {
        'num': '074'
        'name': 'Geodude'
      }
      {
        'num': '075'
        'name': 'Graveler'
      }
    ]
  }
  {
    'id': 77
    'num': '077'
    'name': 'Ponyta'
    'img': 'http://www.serebii.net/pokemongo/pokemon/077.png'
    'type': 'Fire'
    'height': '0.99 m'
    'weight': '30.0 kg'
    'candy': '50 Ponyta Candy'
    'egg': '5 km'
    'multipliers': [
      1.48
      1.5
    ]
    'weaknesses': [
      'Water'
      'Ground'
      'Rock'
    ]
    'next_evolution': [ {
      'num': '078'
      'name': 'Rapidash'
    } ]
  }
  {
    'id': 78
    'num': '078'
    'name': 'Rapidash'
    'img': 'http://www.serebii.net/pokemongo/pokemon/078.png'
    'type': 'Fire'
    'height': '1.70 m'
    'weight': '95.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Ground'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '077'
      'name': 'Ponyta'
    } ]
  }
  {
    'id': 79
    'num': '079'
    'name': 'Slowpoke'
    'img': 'http://www.serebii.net/pokemongo/pokemon/079.png'
    'type': 'Water / Psychic'
    'height': '1.19 m'
    'weight': '36.0 kg'
    'candy': '50 Slowpoke Candy'
    'egg': '5 km'
    'multipliers': 2.21
    'weaknesses': [
      'Electric'
      'Grass'
      'Bug'
      'Ghost'
      'Dark'
    ]
    'next_evolution': [ {
      'num': '080'
      'name': 'Slowbro'
    } ]
  }
  {
    'id': 80
    'num': '080'
    'name': 'Slowbro'
    'img': 'http://www.serebii.net/pokemongo/pokemon/080.png'
    'type': 'Water / Psychic'
    'height': '1.60 m'
    'weight': '78.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Grass'
      'Bug'
      'Ghost'
      'Dark'
    ]
    'prev_evolution': [ {
      'num': '079'
      'name': 'Slowpoke'
    } ]
  }
  {
    'id': 81
    'num': '081'
    'name': 'Magnemite'
    'img': 'http://www.serebii.net/pokemongo/pokemon/081.png'
    'type': 'Electric'
    'height': '0.30 m'
    'weight': '6.0 kg'
    'candy': '50 Magnemite Candy'
    'egg': '5 km'
    'multipliers': [
      2.16
      2.17
    ]
    'weaknesses': [
      'Fire'
      'Water'
      'Ground'
    ]
    'next_evolution': [ {
      'num': '082'
      'name': 'Magneton'
    } ]
  }
  {
    'id': 82
    'num': '082'
    'name': 'Magneton'
    'img': 'http://www.serebii.net/pokemongo/pokemon/082.png'
    'type': 'Electric'
    'height': '0.99 m'
    'weight': '60.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Fire'
      'Water'
      'Ground'
    ]
    'prev_evolution': [ {
      'num': '081'
      'name': 'Magnemite'
    } ]
  }
  {
    'id': 83
    'num': '083'
    'name': 'Farfetch\'d'
    'img': 'http://www.serebii.net/pokemongo/pokemon/083.png'
    'type': 'Normal / Flying'
    'height': '0.79 m'
    'weight': '15.0 kg'
    'candy': 'None'
    'egg': '5 km'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Rock'
    ]
  }
  {
    'id': 84
    'num': '084'
    'name': 'Doduo'
    'img': 'http://www.serebii.net/pokemongo/pokemon/084.png'
    'type': 'Normal / Flying'
    'height': '1.40 m'
    'weight': '39.2 kg'
    'candy': '50 Doduo Candy'
    'egg': '5 km'
    'multipliers': [
      2.19
      2.24
    ]
    'weaknesses': [
      'Electric'
      'Rock'
    ]
    'next_evolution': [ {
      'num': '085'
      'name': 'Dodrio'
    } ]
  }
  {
    'id': 85
    'num': '085'
    'name': 'Dodrio'
    'img': 'http://www.serebii.net/pokemongo/pokemon/085.png'
    'type': 'Normal / Flying'
    'height': '1.80 m'
    'weight': '85.2 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '084'
      'name': 'Doduo'
    } ]
  }
  {
    'id': 86
    'num': '086'
    'name': 'Seel'
    'img': 'http://www.serebii.net/pokemongo/pokemon/086.png'
    'type': 'Water'
    'height': '1.09 m'
    'weight': '90.0 kg'
    'candy': '50 Seel Candy'
    'egg': '5 km'
    'multipliers': [
      1.04
      1.96
    ]
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'next_evolution': [ {
      'num': '087'
      'name': 'Dewgong'
    } ]
  }
  {
    'id': 87
    'num': '087'
    'name': 'Dewgong'
    'img': 'http://www.serebii.net/pokemongo/pokemon/087.png'
    'type': 'Water / Ice'
    'height': '1.70 m'
    'weight': '120.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Grass'
      'Fighting'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '086'
      'name': 'Seel'
    } ]
  }
  {
    'id': 88
    'num': '088'
    'name': 'Grimer'
    'img': 'http://www.serebii.net/pokemongo/pokemon/088.png'
    'type': 'Poison'
    'height': '0.89 m'
    'weight': '30.0 kg'
    'candy': '50 Grimer Candy'
    'egg': '5 km'
    'multipliers': 2.44
    'weaknesses': [
      'Ground'
      'Psychic'
    ]
    'next_evolution': [ {
      'num': '089'
      'name': 'Muk'
    } ]
  }
  {
    'id': 89
    'num': '089'
    'name': 'Muk'
    'img': 'http://www.serebii.net/pokemongo/pokemon/089.png'
    'type': 'Poison'
    'height': '1.19 m'
    'weight': '30.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Ground'
      'Psychic'
    ]
    'prev_evolution': [ {
      'num': '088'
      'name': 'Grimer'
    } ]
  }
  {
    'id': 90
    'num': '090'
    'name': 'Shellder'
    'img': 'http://www.serebii.net/pokemongo/pokemon/090.png'
    'type': 'Water'
    'height': '0.30 m'
    'weight': '4.0 kg'
    'candy': '50 Shellder Candy'
    'egg': '5 km'
    'multipliers': 2.65
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'next_evolution': [ {
      'num': '091'
      'name': 'Cloyster'
    } ]
  }
  {
    'id': 91
    'num': '091'
    'name': 'Cloyster'
    'img': 'http://www.serebii.net/pokemongo/pokemon/091.png'
    'type': 'Water / Ice'
    'height': '1.50 m'
    'weight': '132.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Grass'
      'Fighting'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '090'
      'name': 'Shellder'
    } ]
  }
  {
    'id': 92
    'num': '092'
    'name': 'Gastly'
    'img': 'http://www.serebii.net/pokemongo/pokemon/092.png'
    'type': 'Ghost / Poison'
    'height': '1.30 m'
    'weight': '0.1 kg'
    'candy': '25 Gastly Candy'
    'egg': '5 km'
    'multipliers': 1.78
    'weaknesses': [
      'Ground'
      'Psychic'
      'Ghost'
      'Dark'
    ]
    'next_evolution': [
      {
        'num': '093'
        'name': 'Haunter'
      }
      {
        'num': '094'
        'name': 'Gengar'
      }
    ]
  }
  {
    'id': 93
    'num': '093'
    'name': 'Haunter'
    'img': 'http://www.serebii.net/pokemongo/pokemon/093.png'
    'type': 'Ghost / Poison'
    'height': '1.60 m'
    'weight': '0.1 kg'
    'candy': '100 Gastly Candy'
    'egg': 'Not in Eggs'
    'multipliers': [
      1.56
      1.8
    ]
    'weaknesses': [
      'Ground'
      'Psychic'
      'Ghost'
      'Dark'
    ]
    'prev_evolution': [ {
      'num': '092'
      'name': 'Gastly'
    } ]
    'next_evolution': [ {
      'num': '094'
      'name': 'Gengar'
    } ]
  }
  {
    'id': 94
    'num': '094'
    'name': 'Gengar'
    'img': 'http://www.serebii.net/pokemongo/pokemon/094.png'
    'type': 'Ghost / Poison'
    'height': '1.50 m'
    'weight': '40.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Ground'
      'Psychic'
      'Ghost'
      'Dark'
    ]
    'prev_evolution': [
      {
        'num': '092'
        'name': 'Gastly'
      }
      {
        'num': '093'
        'name': 'Haunter'
      }
    ]
  }
  {
    'id': 95
    'num': '095'
    'name': 'Onix'
    'img': 'http://www.serebii.net/pokemongo/pokemon/095.png'
    'type': 'Rock / Ground'
    'height': '8.79 m'
    'weight': '210.0 kg'
    'candy': 'None'
    'egg': '10 km'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Grass'
      'Ice'
      'Fighting'
      'Ground'
      'Steel'
    ]
  }
  {
    'id': 96
    'num': '096'
    'name': 'Drowzee'
    'img': 'http://www.serebii.net/pokemongo/pokemon/096.png'
    'type': 'Psychic'
    'height': '0.99 m'
    'weight': '32.4 kg'
    'candy': '50 Drowzee Candy'
    'egg': '5 km'
    'multipliers': [
      2.08
      2.09
    ]
    'weaknesses': [
      'Bug'
      'Ghost'
      'Dark'
    ]
    'next_evolution': [ {
      'num': '097'
      'name': 'Hypno'
    } ]
  }
  {
    'id': 97
    'num': '097'
    'name': 'Hypno'
    'img': 'http://www.serebii.net/pokemongo/pokemon/097.png'
    'type': 'Psychic'
    'height': '1.60 m'
    'weight': '75.6 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Bug'
      'Ghost'
      'Dark'
    ]
    'prev_evolution': [ {
      'num': '096'
      'name': 'Drowzee'
    } ]
  }
  {
    'id': 98
    'num': '098'
    'name': 'Krabby'
    'img': 'http://www.serebii.net/pokemongo/pokemon/098.png'
    'type': 'Water'
    'height': '0.41 m'
    'weight': '6.5 kg'
    'candy': '50 Krabby Candy'
    'egg': '5 km'
    'multipliers': [
      2.36
      2.4
    ]
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'next_evolution': [ {
      'num': '099'
      'name': 'Kingler'
    } ]
  }
  {
    'id': 99
    'num': '099'
    'name': 'Kingler'
    'img': 'http://www.serebii.net/pokemongo/pokemon/099.png'
    'type': 'Water'
    'height': '1.30 m'
    'weight': '60.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'prev_evolution': [ {
      'num': '098'
      'name': 'Krabby'
    } ]
  }
  {
    'id': 100
    'num': '100'
    'name': 'Voltorb'
    'img': 'http://www.serebii.net/pokemongo/pokemon/100.png'
    'type': 'Electric'
    'height': '0.51 m'
    'weight': '10.4 kg'
    'candy': '50 Voltorb Candy'
    'egg': '5 km'
    'multipliers': [
      2.01
      2.02
    ]
    'weaknesses': [ 'Ground' ]
    'next_evolution': [ {
      'num': '101'
      'name': 'Electrode'
    } ]
  }
  {
    'id': 101
    'num': '101'
    'name': 'Electrode'
    'img': 'http://www.serebii.net/pokemongo/pokemon/101.png'
    'type': 'Electric'
    'height': '1.19 m'
    'weight': '66.6 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [ 'Ground' ]
    'prev_evolution': [ {
      'num': '100'
      'name': 'Voltorb'
    } ]
  }
  {
    'id': 102
    'num': '102'
    'name': 'Exeggcute'
    'img': 'http://www.serebii.net/pokemongo/pokemon/102.png'
    'type': 'Grass / Psychic'
    'height': '0.41 m'
    'weight': '2.5 kg'
    'candy': '50 Exeggcute Candy'
    'egg': '5 km'
    'multipliers': [
      2.70
      3.18
    ]
    'weaknesses': [
      'Fire'
      'Ice'
      'Poison'
      'Flying'
      'Bug'
      'Ghost'
      'Dark'
    ]
    'next_evolution': [ {
      'num': '103'
      'name': 'Exeggutor'
    } ]
  }
  {
    'id': 103
    'num': '103'
    'name': 'Exeggutor'
    'img': 'http://www.serebii.net/pokemongo/pokemon/103.png'
    'type': 'Grass / Psychic'
    'height': '2.01 m'
    'weight': '120.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Fire'
      'Ice'
      'Poison'
      'Flying'
      'Bug'
      'Ghost'
      'Dark'
    ]
    'prev_evolution': [ {
      'num': '102'
      'name': 'Exeggcute'
    } ]
  }
  {
    'id': 104
    'num': '104'
    'name': 'Cubone'
    'img': 'http://www.serebii.net/pokemongo/pokemon/104.png'
    'type': 'Ground'
    'height': '0.41 m'
    'weight': '6.5 kg'
    'candy': '50 Cubone Candy'
    'egg': '5 km'
    'multipliers': 1.67
    'weaknesses': [
      'Water'
      'Grass'
      'Ice'
    ]
    'next_evolution': [ {
      'num': '105'
      'name': 'Marowak'
    } ]
  }
  {
    'id': 105
    'num': '105'
    'name': 'Marowak'
    'img': 'http://www.serebii.net/pokemongo/pokemon/105.png'
    'type': 'Ground'
    'height': '0.99 m'
    'weight': '45.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Grass'
      'Ice'
    ]
    'prev_evolution': [ {
      'num': '104'
      'name': 'Cubone'
    } ]
  }
  {
    'id': 106
    'num': '106'
    'name': 'Hitmonlee'
    'img': 'http://www.serebii.net/pokemongo/pokemon/106.png'
    'type': 'Fighting'
    'height': '1.50 m'
    'weight': '49.8 kg'
    'candy': 'None'
    'egg': '10 km'
    'multipliers': null
    'weaknesses': [
      'Flying'
      'Psychic'
      'Fairy'
    ]
  }
  {
    'id': 107
    'num': '107'
    'name': 'Hitmonchan'
    'img': 'http://www.serebii.net/pokemongo/pokemon/107.png'
    'type': 'Fighting'
    'height': '1.40 m'
    'weight': '50.2 kg'
    'candy': 'None'
    'egg': '10 km'
    'multipliers': null
    'weaknesses': [
      'Flying'
      'Psychic'
      'Fairy'
    ]
  }
  {
    'id': 108
    'num': '108'
    'name': 'Lickitung'
    'img': 'http://www.serebii.net/pokemongo/pokemon/108.png'
    'type': 'Normal'
    'height': '1.19 m'
    'weight': '65.5 kg'
    'candy': 'None'
    'egg': '5 km'
    'multipliers': null
    'weaknesses': [ 'Fighting' ]
  }
  {
    'id': 109
    'num': '109'
    'name': 'Koffing'
    'img': 'http://www.serebii.net/pokemongo/pokemon/109.png'
    'type': 'Poison'
    'height': '0.61 m'
    'weight': '1.0 kg'
    'candy': '50 Koffing Candy'
    'egg': '5 km'
    'multipliers': 1.11
    'weaknesses': [
      'Ground'
      'Psychic'
    ]
    'next_evolution': [ {
      'num': '110'
      'name': 'Weezing'
    } ]
  }
  {
    'id': 110
    'num': '110'
    'name': 'Weezing'
    'img': 'http://www.serebii.net/pokemongo/pokemon/110.png'
    'type': 'Poison'
    'height': '1.19 m'
    'weight': '9.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Ground'
      'Psychic'
    ]
    'prev_evolution': [ {
      'num': '109'
      'name': 'Koffing'
    } ]
  }
  {
    'id': 111
    'num': '111'
    'name': 'Rhyhorn'
    'img': 'http://www.serebii.net/pokemongo/pokemon/111.png'
    'type': 'Ground / Rock'
    'height': '0.99 m'
    'weight': '115.0 kg'
    'candy': '50 Rhyhorn Candy'
    'egg': '5 km'
    'multipliers': 1.91
    'weaknesses': [
      'Water'
      'Grass'
      'Ice'
      'Fighting'
      'Ground'
      'Steel'
    ]
    'next_evolution': [ {
      'num': '112'
      'name': 'Rhydon'
    } ]
  }
  {
    'id': 112
    'num': '112'
    'name': 'Rhydon'
    'img': 'http://www.serebii.net/pokemongo/pokemon/112.png'
    'type': 'Ground / Rock'
    'height': '1.91 m'
    'weight': '120.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Grass'
      'Ice'
      'Fighting'
      'Ground'
      'Steel'
    ]
    'prev_evolution': [ {
      'num': '111'
      'name': 'Rhyhorn'
    } ]
  }
  {
    'id': 113
    'num': '113'
    'name': 'Chansey'
    'img': 'http://www.serebii.net/pokemongo/pokemon/113.png'
    'type': 'Normal'
    'height': '1.09 m'
    'weight': '34.6 kg'
    'candy': 'None'
    'egg': '10 km'
    'multipliers': null
    'weaknesses': [ 'Fighting' ]
  }
  {
    'id': 114
    'num': '114'
    'name': 'Tangela'
    'img': 'http://www.serebii.net/pokemongo/pokemon/114.png'
    'type': 'Grass'
    'height': '0.99 m'
    'weight': '35.0 kg'
    'candy': 'None'
    'egg': '5 km'
    'multipliers': null
    'weaknesses': [
      'Fire'
      'Ice'
      'Poison'
      'Flying'
      'Bug'
    ]
  }
  {
    'id': 115
    'num': '115'
    'name': 'Kangaskhan'
    'img': 'http://www.serebii.net/pokemongo/pokemon/115.png'
    'type': 'Normal'
    'height': '2.21 m'
    'weight': '80.0 kg'
    'candy': 'None'
    'egg': '5 km'
    'multipliers': null
    'weaknesses': [ 'Fighting' ]
  }
  {
    'id': 116
    'num': '116'
    'name': 'Horsea'
    'img': 'http://www.serebii.net/pokemongo/pokemon/116.png'
    'type': 'Water'
    'height': '0.41 m'
    'weight': '8.0 kg'
    'candy': '50 Horsea Candy'
    'egg': '5 km'
    'multipliers': 2.23
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'next_evolution': [ {
      'num': '117'
      'name': 'Seadra'
    } ]
  }
  {
    'id': 117
    'num': '117'
    'name': 'Seadra'
    'img': 'http://www.serebii.net/pokemongo/pokemon/117.png'
    'type': 'Water'
    'height': '1.19 m'
    'weight': '25.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'prev_evolution': [ {
      'num': '116'
      'name': 'Horsea'
    } ]
  }
  {
    'id': 118
    'num': '118'
    'name': 'Goldeen'
    'img': 'http://www.serebii.net/pokemongo/pokemon/118.png'
    'type': 'Water'
    'height': '0.61 m'
    'weight': '15.0 kg'
    'candy': '50 Goldeen Candy'
    'egg': '5 km'
    'multipliers': [
      2.15
      2.2
    ]
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'next_evolution': [ {
      'num': '119'
      'name': 'Seaking'
    } ]
  }
  {
    'id': 119
    'num': '119'
    'name': 'Seaking'
    'img': 'http://www.serebii.net/pokemongo/pokemon/119.png'
    'type': 'Water'
    'height': '1.30 m'
    'weight': '39.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'prev_evolution': [ {
      'num': '118'
      'name': 'Goldeen'
    } ]
  }
  {
    'id': 120
    'num': '120'
    'name': 'Staryu'
    'img': 'http://www.serebii.net/pokemongo/pokemon/120.png'
    'type': 'Water'
    'height': '0.79 m'
    'weight': '34.5 kg'
    'candy': '50 Staryu Candy'
    'egg': '5 km'
    'multipliers': [
      2.38
      2.41
    ]
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'next_evolution': [ {
      'num': '121'
      'name': 'Starmie'
    } ]
  }
  {
    'id': 121
    'num': '121'
    'name': 'Starmie'
    'img': 'http://www.serebii.net/pokemongo/pokemon/121.png'
    'type': 'Water / Psychic'
    'height': '1.09 m'
    'weight': '80.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Grass'
      'Bug'
      'Ghost'
      'Dark'
    ]
    'prev_evolution': [ {
      'num': '121'
      'name': 'Starmie'
    } ]
  }
  {
    'id': 122
    'num': '122'
    'name': 'Mr. Mime'
    'img': 'http://www.serebii.net/pokemongo/pokemon/122.png'
    'type': 'Psychic'
    'height': '1.30 m'
    'weight': '54.5 kg'
    'candy': 'None'
    'egg': '10 km'
    'multipliers': null
    'weaknesses': [
      'Bug'
      'Ghost'
      'Dark'
    ]
  }
  {
    'id': 123
    'num': '123'
    'name': 'Scyther'
    'img': 'http://www.serebii.net/pokemongo/pokemon/123.png'
    'type': 'Bug / Flying'
    'height': '1.50 m'
    'weight': '56.0 kg'
    'candy': 'None'
    'egg': '10 km'
    'multipliers': null
    'weaknesses': [
      'Fire'
      'Electric'
      'Ice'
      'Flying'
      'Rock'
    ]
  }
  {
    'id': 124
    'num': '124'
    'name': 'Jynx'
    'img': 'http://www.serebii.net/pokemongo/pokemon/124.png'
    'type': 'Ice / Psychic'
    'height': '1.40 m'
    'weight': '40.6 kg'
    'candy': 'None'
    'egg': '10 km'
    'multipliers': null
    'weaknesses': [
      'Fire'
      'Bug'
      'Rock'
      'Ghost'
      'Dark'
      'Steel'
    ]
  }
  {
    'id': 125
    'num': '125'
    'name': 'Electabuzz'
    'img': 'http://www.serebii.net/pokemongo/pokemon/125.png'
    'type': 'Electric'
    'height': '1.09 m'
    'weight': '30.0 kg'
    'candy': 'None'
    'egg': '10 km'
    'multipliers': null
    'weaknesses': [ 'Ground' ]
  }
  {
    'id': 126
    'num': '126'
    'name': 'Magmar'
    'img': 'http://www.serebii.net/pokemongo/pokemon/126.png'
    'type': 'Fire'
    'height': '1.30 m'
    'weight': '44.5 kg'
    'candy': 'None'
    'egg': '10 km'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Ground'
      'Rock'
    ]
  }
  {
    'id': 127
    'num': '127'
    'name': 'Pinsir'
    'img': 'http://www.serebii.net/pokemongo/pokemon/127.png'
    'type': 'Bug'
    'height': '1.50 m'
    'weight': '55.0 kg'
    'candy': 'None'
    'egg': '10 km'
    'multipliers': null
    'weaknesses': [
      'Fire'
      'Flying'
      'Rock'
    ]
  }
  {
    'id': 128
    'num': '128'
    'name': 'Tauros'
    'img': 'http://www.serebii.net/pokemongo/pokemon/128.png'
    'type': 'Normal'
    'height': '1.40 m'
    'weight': '88.4 kg'
    'candy': 'None'
    'egg': '5 km'
    'multipliers': null
    'weaknesses': [ 'Fighting' ]
  }
  {
    'id': 129
    'num': '129'
    'name': 'Magikarp'
    'img': 'http://www.serebii.net/pokemongo/pokemon/129.png'
    'type': 'Water'
    'height': '0.89 m'
    'weight': '10.0 kg'
    'candy': '400 Magikarp Candy'
    'egg': '2 km'
    'multipliers': [
      10.1
      11.8
    ]
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'next_evolution': [ {
      'num': '130'
      'name': 'Gyarados'
    } ]
  }
  {
    'id': 130
    'num': '130'
    'name': 'Gyarados'
    'img': 'http://www.serebii.net/pokemongo/pokemon/130.png'
    'type': 'Water / Flying'
    'height': '6.50 m'
    'weight': '235.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '129'
      'name': 'Magikarp'
    } ]
  }
  {
    'id': 131
    'num': '131'
    'name': 'Lapras'
    'img': 'http://www.serebii.net/pokemongo/pokemon/131.png'
    'type': 'Water / Ice'
    'height': '2.49 m'
    'weight': '220.0 kg'
    'candy': 'None'
    'egg': '10 km'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Grass'
      'Fighting'
      'Rock'
    ]
  }
  {
    'id': 132
    'num': '132'
    'name': 'Ditto'
    'img': 'http://www.serebii.net/pokemongo/pokemon/132.png'
    'type': 'Normal'
    'height': '0.30 m'
    'weight': '4.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [ 'Fighting' ]
  }
  {
    'id': 133
    'num': '133'
    'name': 'Eevee'
    'img': 'http://www.serebii.net/pokemongo/pokemon/133.png'
    'type': 'Normal'
    'height': '0.30 m'
    'weight': '6.5 kg'
    'candy': '25 Eevee Candy (Evolution decided at random. Or, for first evolution, rename Eevee: Rainer => Vaporeon, Sparky => Jolteon, Pyro => Flareon)'
    'egg': '10 km'
    'multipliers': [
      2.02
      2.64
    ]
    'weaknesses': [ 'Fighting' ]
    'next_evolution': [
      {
        'num': '134'
        'name': 'Vaporeon'
      }
      {
        'num': '135'
        'name': 'Jolteon'
      }
      {
        'num': '136'
        'name': 'Flareon'
      }
    ]
  }
  {
    'id': 134
    'num': '134'
    'name': 'Vaporeon'
    'img': 'http://www.serebii.net/pokemongo/pokemon/134.png'
    'type': 'Water'
    'height': '0.99 m'
    'weight': '29.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Grass'
    ]
    'prev_evolution': [ {
      'num': '133'
      'name': 'Eevee'
    } ]
  }
  {
    'id': 135
    'num': '135'
    'name': 'Jolteon'
    'img': 'http://www.serebii.net/pokemongo/pokemon/135.png'
    'type': 'Electric'
    'height': '0.79 m'
    'weight': '24.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [ 'Ground' ]
    'prev_evolution': [ {
      'num': '133'
      'name': 'Eevee'
    } ]
  }
  {
    'id': 136
    'num': '136'
    'name': 'Flareon'
    'img': 'http://www.serebii.net/pokemongo/pokemon/136.png'
    'type': 'Fire'
    'height': '0.89 m'
    'weight': '25.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Ground'
      'Rock'
    ]
    'prev_evolution': [ {
      'num': '133'
      'name': 'Eevee'
    } ]
  }
  {
    'id': 137
    'num': '137'
    'name': 'Porygon'
    'img': 'http://www.serebii.net/pokemongo/pokemon/137.png'
    'type': 'Normal'
    'height': '0.79 m'
    'weight': '36.5 kg'
    'candy': 'None'
    'egg': '5 km'
    'multipliers': null
    'weaknesses': [ 'Fighting' ]
  }
  {
    'id': 138
    'num': '138'
    'name': 'Omanyte'
    'img': 'http://www.serebii.net/pokemongo/pokemon/138.png'
    'type': 'Rock / Water'
    'height': '0.41 m'
    'weight': '7.5 kg'
    'candy': '50 Omanyte Candy'
    'egg': '10 km'
    'multipliers': 2.12
    'weaknesses': [
      'Electric'
      'Grass'
      'Fighting'
      'Ground'
    ]
    'next_evolution': [ {
      'num': '139'
      'name': 'Omastar'
    } ]
  }
  {
    'id': 139
    'num': '139'
    'name': 'Omastar'
    'img': 'http://www.serebii.net/pokemongo/pokemon/139.png'
    'type': 'Rock / Water'
    'height': '0.99 m'
    'weight': '35.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Grass'
      'Fighting'
      'Ground'
    ]
    'prev_evolution': [ {
      'num': '138'
      'name': 'Omanyte'
    } ]
  }
  {
    'id': 140
    'num': '140'
    'name': 'Kabuto'
    'img': 'http://www.serebii.net/pokemongo/pokemon/140.png'
    'type': 'Rock / Water'
    'height': '0.51 m'
    'weight': '11.5 kg'
    'candy': '50 Kabuto Candy'
    'egg': '10 km'
    'multipliers': [
      1.97
      2.37
    ]
    'weaknesses': [
      'Electric'
      'Grass'
      'Fighting'
      'Ground'
    ]
    'next_evolution': [ {
      'num': '141'
      'name': 'Kabutops'
    } ]
  }
  {
    'id': 141
    'num': '141'
    'name': 'Kabutops'
    'img': 'http://www.serebii.net/pokemongo/pokemon/141.png'
    'type': 'Rock / Water'
    'height': '1.30 m'
    'weight': '40.5 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Electric'
      'Grass'
      'Fighting'
      'Ground'
    ]
    'prev_evolution': [ {
      'num': '140'
      'name': 'Kabuto'
    } ]
  }
  {
    'id': 142
    'num': '142'
    'name': 'Aerodactyl'
    'img': 'http://www.serebii.net/pokemongo/pokemon/142.png'
    'type': 'Rock / Flying'
    'height': '1.80 m'
    'weight': '59.0 kg'
    'candy': 'None'
    'egg': '10 km'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Electric'
      'Ice'
      'Rock'
      'Steel'
    ]
  }
  {
    'id': 143
    'num': '143'
    'name': 'Snorlax'
    'img': 'http://www.serebii.net/pokemongo/pokemon/143.png'
    'type': 'Normal'
    'height': '2.11 m'
    'weight': '460.0 kg'
    'candy': 'None'
    'egg': '10 km'
    'multipliers': null
    'weaknesses': [ 'Fighting' ]
  }
  {
    'id': 144
    'num': '144'
    'name': 'Articuno'
    'img': 'http://www.serebii.net/pokemongo/pokemon/144.png'
    'type': 'Ice / Flying'
    'height': '1.70 m'
    'weight': '55.4 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Fire'
      'Electric'
      'Rock'
      'Steel'
    ]
  }
  {
    'id': 145
    'num': '145'
    'name': 'Zapdos'
    'img': 'http://www.serebii.net/pokemongo/pokemon/145.png'
    'type': 'Electric / Flying'
    'height': '1.60 m'
    'weight': '52.6 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Ice'
      'Rock'
    ]
  }
  {
    'id': 146
    'num': '146'
    'name': 'Moltres'
    'img': 'http://www.serebii.net/pokemongo/pokemon/146.png'
    'type': 'Fire / Flying'
    'height': '2.01 m'
    'weight': '60.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Water'
      'Electric'
      'Rock'
    ]
  }
  {
    'id': 147
    'num': '147'
    'name': 'Dratini'
    'img': 'http://www.serebii.net/pokemongo/pokemon/147.png'
    'type': 'Dragon'
    'height': '1.80 m'
    'weight': '3.3 kg'
    'candy': '25 Dratini Candy'
    'egg': '10 km'
    'multipliers': [
      1.83
      1.84
    ]
    'weaknesses': [
      'Ice'
      'Dragon'
      'Fairy'
    ]
    'next_evolution': [
      {
        'num': '148'
        'name': 'Dragonair'
      }
      {
        'num': '149'
        'name': 'Dragonite'
      }
    ]
  }
  {
    'id': 148
    'num': '148'
    'name': 'Dragonair'
    'img': 'http://www.serebii.net/pokemongo/pokemon/148.png'
    'type': 'Dragon'
    'height': '3.99 m'
    'weight': '16.5 kg'
    'candy': '100 Dratini Candy'
    'egg': 'Not in Eggs'
    'multipliers': 2.05
    'weaknesses': [
      'Ice'
      'Dragon'
      'Fairy'
    ]
    'next_evolution': [ {
      'num': '149'
      'name': 'Dragonite'
    } ]
  }
  {
    'id': 149
    'num': '149'
    'name': 'Dragonite'
    'img': 'http://www.serebii.net/pokemongo/pokemon/149.png'
    'type': 'Dragon / Flying'
    'height': '2.21 m'
    'weight': '210.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Ice'
      'Rock'
      'Dragon'
      'Fairy'
    ]
    'prev_evolution': [ {
      'num': '148'
      'name': 'Dragonair'
    } ]
  }
  {
    'id': 150
    'num': '150'
    'name': 'Mewtwo'
    'img': 'http://www.serebii.net/pokemongo/pokemon/150.png'
    'type': 'Psychic'
    'height': '2.01 m'
    'weight': '122.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Bug'
      'Ghost'
      'Dark'
    ]
  }
  {
    'id': 151
    'num': '151'
    'name': 'Mew'
    'img': 'http://www.serebii.net/pokemongo/pokemon/151.png'
    'type': 'Psychic'
    'height': '0.41 m'
    'weight': '4.0 kg'
    'candy': 'None'
    'egg': 'Not in Eggs'
    'multipliers': null
    'weaknesses': [
      'Bug'
      'Ghost'
      'Dark'
    ]
  }
]


pokemonBaseStats =
  'Bulbasaur':
    'Attack': 126
    'Defense': 126
    'Stamina': 90
  'Ivysaur':
    'Attack': 156
    'Defense': 158
    'Stamina': 120
  'Venusaur':
    'Attack': 198
    'Defense': 200
    'Stamina': 160
  'Charmander':
    'Attack': 128
    'Defense': 108
    'Stamina': 78
  'Charmeleon':
    'Attack': 160
    'Defense': 140
    'Stamina': 116
  'Charizard':
    'Attack': 212
    'Defense': 182
    'Stamina': 156
  'Squirtle':
    'Attack': 112
    'Defense': 142
    'Stamina': 88
  'Wartortle':
    'Attack': 144
    'Defense': 176
    'Stamina': 118
  'Blastoise':
    'Attack': 186
    'Defense': 222
    'Stamina': 158
  'Caterpie':
    'Attack': 62
    'Defense': 66
    'Stamina': 90
  'Metapod':
    'Attack': 56
    'Defense': 86
    'Stamina': 100
  'Butterfree':
    'Attack': 144
    'Defense': 144
    'Stamina': 120
  'Weedle':
    'Attack': 68
    'Defense': 64
    'Stamina': 80
  'Kakuna':
    'Attack': 62
    'Defense': 82
    'Stamina': 90
  'Beedrill':
    'Attack': 144
    'Defense': 130
    'Stamina': 130
  'Pidgey':
    'Attack': 94
    'Defense': 90
    'Stamina': 80
  'Pidgeotto':
    'Attack': 126
    'Defense': 122
    'Stamina': 126
  'Pidgeot':
    'Attack': 170
    'Defense': 166
    'Stamina': 166
  'Rattata':
    'Attack': 92
    'Defense': 86
    'Stamina': 60
  'Raticate':
    'Attack': 146
    'Defense': 150
    'Stamina': 110
  'Spearow':
    'Attack': 102
    'Defense': 78
    'Stamina': 80
  'Fearow':
    'Attack': 168
    'Defense': 146
    'Stamina': 130
  'Ekans':
    'Attack': 112
    'Defense': 112
    'Stamina': 70
  'Arbok':
    'Attack': 166
    'Defense': 166
    'Stamina': 120
  'Pikachu':
    'Attack': 124
    'Defense': 108
    'Stamina': 70
  'Raichu':
    'Attack': 200
    'Defense': 154
    'Stamina': 120
  'Sandshrew':
    'Attack': 90
    'Defense': 114
    'Stamina': 100
  'Sandslash':
    'Attack': 150
    'Defense': 172
    'Stamina': 150
  'Nidoran♀':
    'Attack': 100
    'Defense': 104
    'Stamina': 110
  'Nidorina':
    'Attack': 132
    'Defense': 136
    'Stamina': 140
  'Nidoqueen':
    'Attack': 184
    'Defense': 190
    'Stamina': 180
  'Nidoran♂':
    'Attack': 110
    'Defense': 94
    'Stamina': 92
  'Nidorino':
    'Attack': 142
    'Defense': 128
    'Stamina': 122
  'Nidoking':
    'Attack': 204
    'Defense': 170
    'Stamina': 162
  'Clefairy':
    'Attack': 116
    'Defense': 124
    'Stamina': 140
  'Clefable':
    'Attack': 178
    'Defense': 178
    'Stamina': 190
  'Vulpix':
    'Attack': 106
    'Defense': 118
    'Stamina': 76
  'Ninetales':
    'Attack': 176
    'Defense': 194
    'Stamina': 146
  'Jigglypuff':
    'Attack': 98
    'Defense': 54
    'Stamina': 230
  'Wigglytuff':
    'Attack': 168
    'Defense': 108
    'Stamina': 280
  'Zubat':
    'Attack': 88
    'Defense': 90
    'Stamina': 80
  'Golbat':
    'Attack': 164
    'Defense': 164
    'Stamina': 150
  'Oddish':
    'Attack': 134
    'Defense': 130
    'Stamina': 90
  'Gloom':
    'Attack': 162
    'Defense': 158
    'Stamina': 120
  'Vileplume':
    'Attack': 202
    'Defense': 190
    'Stamina': 150
  'Paras':
    'Attack': 122
    'Defense': 120
    'Stamina': 70
  'Parasect':
    'Attack': 162
    'Defense': 170
    'Stamina': 120
  'Venonat':
    'Attack': 108
    'Defense': 118
    'Stamina': 120
  'Venomoth':
    'Attack': 172
    'Defense': 154
    'Stamina': 140
  'Diglett':
    'Attack': 108
    'Defense': 86
    'Stamina': 20
  'Dugtrio':
    'Attack': 148
    'Defense': 140
    'Stamina': 70
  'Meowth':
    'Attack': 104
    'Defense': 94
    'Stamina': 80
  'Persian':
    'Attack': 156
    'Defense': 146
    'Stamina': 130
  'Psyduck':
    'Attack': 132
    'Defense': 112
    'Stamina': 100
  'Golduck':
    'Attack': 194
    'Defense': 176
    'Stamina': 160
  'Mankey':
    'Attack': 122
    'Defense': 96
    'Stamina': 80
  'Primeape':
    'Attack': 178
    'Defense': 150
    'Stamina': 130
  'Growlithe':
    'Attack': 156
    'Defense': 110
    'Stamina': 110
  'Arcanine':
    'Attack': 230
    'Defense': 180
    'Stamina': 180
  'Poliwag':
    'Attack': 108
    'Defense': 98
    'Stamina': 80
  'Poliwhirl':
    'Attack': 132
    'Defense': 132
    'Stamina': 130
  'Poliwrath':
    'Attack': 180
    'Defense': 202
    'Stamina': 180
  'Abra':
    'Attack': 110
    'Defense': 76
    'Stamina': 50
  'Kadabra':
    'Attack': 150
    'Defense': 112
    'Stamina': 80
  'Alakazam':
    'Attack': 186
    'Defense': 152
    'Stamina': 110
  'Machop':
    'Attack': 118
    'Defense': 96
    'Stamina': 140
  'Machoke':
    'Attack': 154
    'Defense': 144
    'Stamina': 160
  'Machamp':
    'Attack': 198
    'Defense': 180
    'Stamina': 180
  'Bellsprout':
    'Attack': 158
    'Defense': 78
    'Stamina': 100
  'Weepinbell':
    'Attack': 190
    'Defense': 110
    'Stamina': 130
  'Victreebel':
    'Attack': 222
    'Defense': 152
    'Stamina': 160
  'Tentacool':
    'Attack': 106
    'Defense': 136
    'Stamina': 80
  'Tentacruel':
    'Attack': 170
    'Defense': 196
    'Stamina': 160
  'Geodude':
    'Attack': 106
    'Defense': 118
    'Stamina': 80
  'Graveler':
    'Attack': 142
    'Defense': 156
    'Stamina': 110
  'Golem':
    'Attack': 176
    'Defense': 198
    'Stamina': 160
  'Ponyta':
    'Attack': 168
    'Defense': 138
    'Stamina': 100
  'Rapidash':
    'Attack': 200
    'Defense': 170
    'Stamina': 130
  'Slowpoke':
    'Attack': 110
    'Defense': 110
    'Stamina': 180
  'Slowbro':
    'Attack': 184
    'Defense': 198
    'Stamina': 190
  'Magnemite':
    'Attack': 128
    'Defense': 138
    'Stamina': 50
  'Magneton':
    'Attack': 186
    'Defense': 180
    'Stamina': 100
  'Farfetch\'d':
    'Attack': 138
    'Defense': 132
    'Stamina': 104
  'Doduo':
    'Attack': 126
    'Defense': 96
    'Stamina': 70
  'Dodrio':
    'Attack': 182
    'Defense': 150
    'Stamina': 120
  'Seel':
    'Attack': 104
    'Defense': 138
    'Stamina': 130
  'Dewgong':
    'Attack': 156
    'Defense': 192
    'Stamina': 180
  'Grimer':
    'Attack': 124
    'Defense': 110
    'Stamina': 160
  'Muk':
    'Attack': 180
    'Defense': 188
    'Stamina': 210
  'Shellder':
    'Attack': 120
    'Defense': 112
    'Stamina': 60
  'Cloyster':
    'Attack': 196
    'Defense': 196
    'Stamina': 100
  'Gastly':
    'Attack': 136
    'Defense': 82
    'Stamina': 60
  'Haunter':
    'Attack': 172
    'Defense': 118
    'Stamina': 90
  'Gengar':
    'Attack': 204
    'Defense': 156
    'Stamina': 120
  'Onix':
    'Attack': 90
    'Defense': 186
    'Stamina': 70
  'Drowzee':
    'Attack': 104
    'Defense': 140
    'Stamina': 120
  'Hypno':
    'Attack': 162
    'Defense': 196
    'Stamina': 170
  'Krabby':
    'Attack': 116
    'Defense': 110
    'Stamina': 60
  'Kingler':
    'Attack': 178
    'Defense': 168
    'Stamina': 110
  'Voltorb':
    'Attack': 102
    'Defense': 124
    'Stamina': 80
  'Electrode':
    'Attack': 150
    'Defense': 174
    'Stamina': 120
  'Exeggcute':
    'Attack': 110
    'Defense': 132
    'Stamina': 120
  'Exeggutor':
    'Attack': 232
    'Defense': 164
    'Stamina': 190
  'Cubone':
    'Attack': 102
    'Defense': 150
    'Stamina': 100
  'Marowak':
    'Attack': 140
    'Defense': 202
    'Stamina': 120
  'Hitmonlee':
    'Attack': 148
    'Defense': 172
    'Stamina': 100
  'Hitmonchan':
    'Attack': 138
    'Defense': 204
    'Stamina': 100
  'Lickitung':
    'Attack': 126
    'Defense': 160
    'Stamina': 180
  'Koffing':
    'Attack': 136
    'Defense': 142
    'Stamina': 80
  'Weezing':
    'Attack': 190
    'Defense': 198
    'Stamina': 130
  'Rhyhorn':
    'Attack': 110
    'Defense': 116
    'Stamina': 160
  'Rhydon':
    'Attack': 166
    'Defense': 160
    'Stamina': 210
  'Chansey':
    'Attack': 40
    'Defense': 60
    'Stamina': 500
  'Tangela':
    'Attack': 164
    'Defense': 152
    'Stamina': 130
  'Kangaskhan':
    'Attack': 142
    'Defense': 178
    'Stamina': 210
  'Horsea':
    'Attack': 122
    'Defense': 100
    'Stamina': 60
  'Seadra':
    'Attack': 176
    'Defense': 150
    'Stamina': 110
  'Goldeen':
    'Attack': 112
    'Defense': 126
    'Stamina': 90
  'Seaking':
    'Attack': 172
    'Defense': 160
    'Stamina': 160
  'Staryu':
    'Attack': 130
    'Defense': 128
    'Stamina': 60
  'Starmie':
    'Attack': 194
    'Defense': 192
    'Stamina': 120
  'Mr. Mime':
    'Attack': 154
    'Defense': 196
    'Stamina': 80
  'Scyther':
    'Attack': 176
    'Defense': 180
    'Stamina': 140
  'Jynx':
    'Attack': 172
    'Defense': 134
    'Stamina': 130
  'Electabuzz':
    'Attack': 198
    'Defense': 160
    'Stamina': 130
  'Magmar':
    'Attack': 214
    'Defense': 158
    'Stamina': 130
  'Pinsir':
    'Attack': 184
    'Defense': 186
    'Stamina': 130
  'Tauros':
    'Attack': 148
    'Defense': 184
    'Stamina': 150
  'Magikarp':
    'Attack': 42
    'Defense': 84
    'Stamina': 40
  'Gyarados':
    'Attack': 192
    'Defense': 196
    'Stamina': 190
  'Lapras':
    'Attack': 186
    'Defense': 190
    'Stamina': 260
  'Ditto':
    'Attack': 110
    'Defense': 110
    'Stamina': 96
  'Eevee':
    'Attack': 114
    'Defense': 128
    'Stamina': 110
  'Vaporeon':
    'Attack': 186
    'Defense': 168
    'Stamina': 260
  'Jolteon':
    'Attack': 192
    'Defense': 174
    'Stamina': 130
  'Flareon':
    'Attack': 238
    'Defense': 178
    'Stamina': 130
  'Porygon':
    'Attack': 156
    'Defense': 158
    'Stamina': 130
  'Omanyte':
    'Attack': 132
    'Defense': 160
    'Stamina': 70
  'Omastar':
    'Attack': 180
    'Defense': 202
    'Stamina': 140
  'Kabuto':
    'Attack': 148
    'Defense': 142
    'Stamina': 60
  'Kabutops':
    'Attack': 190
    'Defense': 190
    'Stamina': 120
  'Aerodactyl':
    'Attack': 182
    'Defense': 162
    'Stamina': 160
  'Snorlax':
    'Attack': 180
    'Defense': 180
    'Stamina': 320
  'Articuno':
    'Attack': 198
    'Defense': 242
    'Stamina': 180
  'Zapdos':
    'Attack': 232
    'Defense': 194
    'Stamina': 180
  'Moltres':
    'Attack': 242
    'Defense': 194
    'Stamina': 180
  'Dratini':
    'Attack': 128
    'Defense': 110
    'Stamina': 82
  'Dragonair':
    'Attack': 170
    'Defense': 152
    'Stamina': 122
  'Dragonite':
    'Attack': 250
    'Defense': 212
    'Stamina': 182
  'Mewtwo':
    'Attack': 284
    'Defense': 202
    'Stamina': 212
  'Mew':
    'Attack': 220
    'Defense': 220
    'Stamina': 200

###########################################################
# Model and util functions
###########################################################

clamp = (min, x, max) ->
  Math.min Math.max(min, x), max

round = (x, places) ->
  Math.min Math.max(min, x), max

pokemon_t = (species, hp, cp, dustPrice, level) ->
  @species = species
  @hp = hp
  @cp = cp
  @dustPrice = dustPrice
  @STA = pokemonBaseStats[species].Stamina
  @ATT = pokemonBaseStats[species].Attack
  @DEF = pokemonBaseStats[species].Defense
  @IVs =
    STA: -1
    ATT: -1
    DEF: -1
  if level
    @setLevel level
  if !level
    i = 0
    while i < levelsByStardust.length
      if dustPrice == levelsByStardust[i]['stardust']
        @levelMin = levelsByStardust[i]['level']
        @levelMax = levelsByStardust[i + 1]['level'] - 0.5
        break
      i++
  return

pokemon_t::compositeSTA = (iv) ->
  iv = iv or @IVs.STA
  (@STA + iv) * @getCpMultiplier()

pokemon_t::compositeATT = (iv) ->
  iv = iv or @IVs.ATT
  (@ATT + iv) * @getCpMultiplier()

pokemon_t::compositeDEF = (iv) ->
  iv = iv or @IVs.DEF
  (@DEF + iv) * @getCpMultiplier()

pokemon_t::getCp = (sta, att, def) ->
  Math.floor 0.1 * @compositeSTA(sta) ** 0.5 * @compositeATT(att) * @compositeDEF(def) ** 0.5

pokemon_t::getHp = (sta) ->
  Math.floor @compositeSTA(sta)

pokemon_t::getCpMultiplier = ->
  cpMultiplierByLevel['' + @level]

pokemon_t::setLevel = (lvl) ->
  @level = lvl
  minHP = @getHp(0)
  maxHP = @getHp(15)
  if @hp < @getHp(0) or @hp > @getHp(15)
    return false
  min = clamp(0, @hp / @getCpMultiplier() - (@STA), 15)
  max = clamp(0, (@hp + 1.0) / @getCpMultiplier() - (@STA), 15)
  @IVs.STA = (min + max) / 2
  if @cp < @getCp(min, 0, 0) or @cp > @getCp(max, 15, 15)
    return false
  best = 
    distance: Number.MAX_VALUE
    IV: 0
  # calculate ATT and DEF IVs, assuming ATT = DEF
  x = -0.05
  while x <= 15.05
    cp = @getCp(null, x, x)
    if Math.abs(@cp - cp) < best.distance
      best.distance = Math.abs(@cp - cp)
      best.IV = x
    x += 0.05
  @IVs.ATT = best.IV
  @IVs.DEF = best.IV
  true


printPokemon = (pokemon) ->
  response = ''
#  for k,v of pokemon
#    response += "#{k}: #{v?.toString()}\n"
  response += "#{pokemon.name} (#{pokemon.num})\n"
  response += "#{pokemon.type ? 'No recorded type'}\n"
  response += "Height: #{pokemon.height ? 'No recorded height'} / Weight: #{pokemon.weight ? 'No recorded weight'}\n"
  response += "Evolve Cost: #{pokemon.candy ? 'No recorded candy'} / hatched from #{pokemon.egg ? 'No recorded egg'}\n"
  response += "Weaknesses: #{pokemon.weaknesses ? 'No recorded weaknesses'}\n"
  if pokemon.prev_evolution
    response += "Previous evolution: #{pokemon.prev_evolution[0].name}"
  if pokemon.next_evolution
    response += "Next evolution: #{pokemon.next_evolution[0].name}"
  return response

getPokemonByName = (pokemonName) ->
  return _.find pokedexData, (pokemon) -> pokemon.name.toLowerCase() is pokemonName.toLowerCase()


formatIVs = (validCombo) ->
  stamina = validCombo[1]
  attack = validCombo[2]
  defense = validCombo[3]
  response = ""
  response += "*STA*: #{round(stamina, 2)} "
  response += "*ATK*: #{round(attack, 2)} "
  response += "*DEF*: #{round(defense, 2)}\n"
  response += "That's a #{round((stamina+attack+defense)/45*100, 2)}% perfect pokemon!"
  return response

module.exports = (robot) ->
  
  robot.respond /pokedex ([0-9]+)$/i, (res) ->
    pokedexId = parseInt(res.match[1], 10)

    pokedexEntry = _.find pokedexData, (pokemon) -> pokemon.id is pokedexId 

    res.send printPokemon(pokedexEntry)

  robot.respond /pokemon attributes$/i, (res) ->
    res.send "Pokedex entries have the following attributes: id, num, name, img, type, height, weight, candy, egg, multipliers, weaknesses, next_evolution, prev_evolution"

  robot.respond /pokemon calculate ([A-z]+) ([0-9]+) ([0-9]+) ([0-9]+)$/i, (res) ->
    pokemonName = res.match[1]
    pokemonHP = parseInt(res.match[2], 10)
    pokemonCP = parseInt(res.match[3], 10)
    pokemonDustPrice = parseInt(res.match[4], 10)
    poweredUp = false

    if !pokemonBaseStats[pokemonName]
      res.send "Could not find pokemon named #{pokemonName}. Please ensure the first letter is capitalized and the pokemon is spelled correctly."
      return

    myPokemon = new pokemon(pokemonName, pokemonHP, pokemonCP, pokemonDustPrice)

    loopIncrement = if poweredUp then 0.5 else 1

    valids = []
    all = []

    for i in [ myPokemon.levelMin ... myPokemon.levelMax ] by loopIncrement
      valid = myPokemon.setLevel(i)

      out = [ myPokemon.level, myPokemon.IVs.STA, myPokemon.IVs.ATT, myPokemon.IVs.DEF ]

      myPokemon.IVs.STA = -1;
      myPokemon.IVs.ATT = -1;
      myPokemon.IVs.DEF = -1;

      if valid
        valids.push out

      all.push out
    
    response = ""
    #console.log "Got #{valids.length} valid, #{all.length} all"
    if valids.length is 1
      stamina = valids[0][1]
      attack = valids[0][2]
      defense = valids[0][3]
      response += formatIVs(valids[0])
      res.send response
    else if valids.length > 1
      response += "We have multiple possible combinations here: \n"
      for validivs in valids
        response += formatIVs(validivs)
        response += "\n"
      res.send response
    else
      res.send "No possibilities found :("

  robot.respond /pokedex ([A-z]+)\s?([A-z]+)?$/i, (res) ->
    pokemonName = res.match[1]
    pokemonProperty = res.match[2]

    pokedexEntry = getPokemonByName(pokemonName)
    
    if !pokedexEntry?
        res.send "Cannot find pokemon with name #{pokemonName}"
        return

    if pokemonProperty
      res.send pokedexEntry[pokemonProperty.toLowerCase()]?.toString() ? "#{pokemonName} has no property #{pokemonProperty}"
    else
      res.send printPokemon(pokedexEntry)

  robot.respond /evolve ([A-z]+) ([0-9]+)$/i, (res) ->
    pokemonName = res.match[1]
    pokemonLevel = parseInt(res.match[2], 10)

    pokedexEntry = getPokemonByName(pokemonName)
    if !pokedexEntry.multipliers?
      res.send "#{pokemonName} has no multipliers"
      return
    #if typeof pokedexEntry.multipliers is 'array'
    if Object.prototype.toString.call pokedexEntry.multipliers is '[object Array]'
      response = "Max evolved CP for #{pokedexEntry.name} is #{ Math.round(pokemonLevel *
      pokedexEntry.multipliers[1]) }\n"
      response += "Minimum evolved CP for #{pokedexEntry.name} is #{ Math.round(pokemonLevel *
      pokedexEntry.multipliers[0]) }"
      res.send response
    else if typeof pokedexEntry.multipliers is 'number'
      res.send "Evolved CP for #{ pokedexEntry.name } is #{ Math.round(pokemonLevel *
      pokedexEntry.multipliers) }"
