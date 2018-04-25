import React from 'react';
import Select from 'react-select';

export default class ProductSelect extends React.Component {
    constructor(){
        super();
        this.state = {productName:"Ballerina"}
    }
    productNameChange = (value) => {
        this.setState({ productName:value });
        this.props.callbackParent(value);
    };

    render() {
        const selectStyle = {
            fontFamily: "Helvetica",
            maxWidth: 300,
            fontSize: 14,
            textAlign: "left"
        };
        const titleStyle = {
            fontFamily: "Helvetica",
            fontSize: 16,
            fontWeight: 400,
            color: "#464646"
        };
        return (
            <div align="center">
                <br/>
                <p style={titleStyle}>WSO2 Product Name</p>
                <div style={selectStyle}>
                    <Select
                        name="Product Name"
                        onChange={this.productNameChange.bind(this)}
                        options={[
                            { value: 'All', label: 'All' },
                            { value: 'API_Management', label: 'API Management' },
                            { value: 'Automation', label: 'Automation' },
                            { value: 'Ballerina', label: 'Ballerina' },
                            { value: 'Cloud', label: 'Cloud' },
                            { value: 'Financial_Solutions', label: 'Financial Solutions' },
                            { value: 'Identity_and_Access_Management', label: 'Identity and Access Management' },
                            { value: 'Integration', label: 'Integration' },
                            { value: 'IoT', label: 'IoT' },
                            { value: 'Platform', label: 'Platform' },
                            { value: 'Platform_Extension', label: 'Platform Extension' },
                            { value: 'Research', label: 'Research' },
                            { value: 'Streaming_Analytics', label: 'Streaming_Analytics' },
                            { value: 'unknown', label: 'unknown' },
                        ]}
                    />
                </div>
            </div>
        );
    }
}