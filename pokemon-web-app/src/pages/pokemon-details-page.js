import React from 'react';
import { List, ListItem } from 'material-ui/List';
import PokemonListItem from '../components/pokemon-list-item.js';
import {
    Table,
    TableBody,
    TableHeader,
    TableHeaderColumn,
    TableRow,
    TableRowColumn,
} from 'material-ui/Table';

export default class PokemonDetailsPage extends React.Component {
    render() {
        return (
            <div>
                <h1>
                    Hi {this.props.pokemon.PokemonNickName}
                </h1>
                <img
                    style={{ width: 50, height: 50 }}
                    src={`http://www.pokestadium.com/sprites/xy/${this.props.pokemon.Species.toLowerCase()}.gif`}
                />
            </div>
            
        );
    }
}