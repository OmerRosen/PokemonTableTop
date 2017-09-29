import React from 'react';
import {List, ListItem} from 'material-ui/List';
import PokemonListItem from '../components/pokemon-list-item.js';

export default class TrainerDetailsPage extends React.Component {
    render() {
        return (
            <div>
                <h1>
                    HI {this.props.trainer.OwnerName}.
                </h1>
                <List>
                    {this.props.pokemons.map(function (x) {return <PokemonListItem pokemon={x} />})}
                </List>
            </div>
        );
    }
}