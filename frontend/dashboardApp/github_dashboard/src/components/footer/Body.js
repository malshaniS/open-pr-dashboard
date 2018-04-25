import React from 'react';

export default class Body extends React.Component {
    render() {
        const h3Style = {
            fontSize:16,
            margin:5,
            textAlign:"center",
            color:"#888888",
            fontFamily:"Helvetica",
            fontWeight:100
        };
        return (
            <div>
                <p style={h3Style}>Copyright (c) 2018 | WSO2 Inc.<br/> All Right Reserved. </p>
            </div>
        );
    }
}
