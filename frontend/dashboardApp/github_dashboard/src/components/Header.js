import React from 'react';
import Title from "./header/Title";

export default class Header extends React.Component {

    render() {
        const headerStyle = {
            backgroundColor: "#010101",
            width: "100%",
            height: 20,
            padding: 10,
        };

        return (
            <div style={headerStyle}>
                <Title/>
            </div>
        );
    }
}
