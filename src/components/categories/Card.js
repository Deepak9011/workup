import React from 'react';
import './Card';

function Card(props) {
    return (
        <>
            <div className="card">
                <h2 className="card-title">{props.title}</h2>
                <img src={props.imageUrl} alt={props.title} className="card-image" />
                <button className="explore-button">Explore</button>
            </div>

        </>
    );
}

export default Card;