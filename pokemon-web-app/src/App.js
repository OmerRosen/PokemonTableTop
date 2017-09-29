import React, { Component } from 'react';

import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import {
  BrowserRouter as Router,
  Route,
  Link
} from 'react-router-dom';

import logo from './logo.svg';
import './App.css';
import HomePage from './pages/home-page';
import PokemonDetailsPage from './pages/pokemon-details-page';
import TrainerDetailsPage from './pages/trainer-details-page';
import BattlePage from './pages/battle-page';
import trainers from './data/trainers.json';
import pokemons from './data/pokemons.json';
import trainersforbattle from './data/AvailableTrainers.json';


class App extends Component {

  constructor(props) {
    super(props);

    this.state = {
      pokemons: pokemons,
      trainers: trainers
    }
  }

  render() {
    return (
      <MuiThemeProvider>
        <Router>
          <div className="App">
            <div className="App-header">
              <img src={"http://a.deviantart.net/avatars/i/m/imaridearocketship.gif?1"} className="App-logo" alt="logo" />
              <h2>Welcome to Oak's Sexy-ass Dungeon</h2>
            </div>

            <Route path="/trainer/:name" component={(props) => (
              <TrainerDetailsPage
                pokemons={this.state.pokemons.filter(x => x.OwnerName == props.match.params.name)}
                trainer={this.state.trainers.find(x => x.OwnerName == props.match.params.name)} />
            )} />
            <Route path="/battle" component={(props) => (
              <BattlePage
              trainersforbattle={this.state.trainers}
              />
            )} />
            <Route path="/pokemon/:id" component={(props) => (
              <PokemonDetailsPage
                pokemon={this.state.pokemons.find(x => x.PokemonId == props.match.params.id)}
              />
            )} />
            <Route exact={true} path="/" component={(props) => (
              <HomePage
                trainers={this.state.trainers}
                pokemons={this.state.pokemons} />
            )} />
          </div>
        </Router>
      </MuiThemeProvider>

    );
  }

  componentDidMount() {
    (async () => {
      try {
        const result = await fetch("http://demo9455479.mockable.io/pokemons");
        const pokemons = await result.json();

        this.setState({
          pokemons: pokemons
        })
      } catch (err) {
        // ... error checks
        console.error(err);
      }
    })();
  }
}


export default App;
