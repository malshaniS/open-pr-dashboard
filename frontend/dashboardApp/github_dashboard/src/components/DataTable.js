import React from 'react';
import Request from 'react-http-request';
import { TacoTable, DataType } from 'react-taco-table';
import '../styles/react-taco-table.css'

var configData = require('../resouses/config');
const URL = configData.SERVER_URL_TABLE;

const columns = [
    {
        id: 'prStatus',
        type: DataType.String,
        header: 'Status',
        borderRadius:10,
        tdStyle(cellData) {
            if (cellData === "Late") {
                return { backgroundColor: `rgba(255, 149, 0, 0.9)`,fontWeight: 'bold', color:'white', textAlign:'center', fontFamily:'Helvetica',fontSize:15, };
            } else if (cellData === "Normal") {
                return { backgroundColor: `rgba(99, 218, 56, 1)`, fontWeight: 'bold', color:'white',fontSize:15,};
            }

        },
    },
    {
        id: 'productName',
        type: DataType.String,
        borderRadius:20,
        header: 'Product',
        width:150,
        tdStyle(cellData) {
            if (cellData === "API Management") {
                return { fontWeight: 'bold', color:'#007', textAlign:'center', fontFamily:'Helvetica',fontSize:15, };
            } else if (cellData === "Platform") {
                return { fontWeight: 'bold', textAlign:'center',color:'#040',fontSize:15,};
            } else if (cellData === "Integration") {
                return { fontWeight: 'bold', textAlign:'center',color:'#953',fontSize:15,};
            } else if (cellData === "Identity and Access Management") {
                return { fontWeight: 'bold', textAlign:'center',color:'#600',fontSize:15,};
            } else if (cellData === "Streaming Analytics") {
                return { fontWeight: 'bold', textAlign:'center',color:'#707',fontSize:15,};
            } else if (cellData === "IoT") {
                return { fontWeight: 'bold', textAlign:'center',color:'#079',fontSize:15,};
            } else if (cellData === "Automation") {
                return { fontWeight: 'bold', textAlign:'center',color:'#475',fontSize:15,};
            }

        },
    },
    {
        id: 'prTitle',
        type: DataType.String,
        header: 'Pull Request Title',
        width:520,
        tdStyle() {
            return { color:'#111', textAlign:'left', fontFamily:'Helvetica',fontSize:15,};

        },
    },
    {
        id: 'prURL',
        type: DataType.String,
        header: 'Pull Request Url',
        width:500,
        renderer(cellData, { column, rowData }) {
            return <a href={rowData.prURL} target="_blank">{cellData}</a>;
        },
        tdStyle() {
            return { color:'black', textAlign:'left', fontFamily:'Helvetica',fontSize:16,};

        },
    },
    {
        id: 'gitId',
        type: DataType.String,
        header: 'User ID',
        width:30,
        tdStyle() {
            return { color:'#111', textAlign:'left', fontFamily:'Helvetica',fontSize:17,};

        },
    },

    {
        id: 'durationWeeks',
        type: DataType.Number,
        header: 'Duration (weeks)',
        tdStyle() {
            return { textAlign:'center', fontFamily:'Helvetica',width:100,fontSize:16,fontWeight: 'bold', };
        },
    },
    {
        id: 'durationDays',
        type: DataType.Number,
        header: 'Duration (days)',
        width:50,
        tdStyle() {
            return { textAlign:'center', fontFamily:'Helvetica',width:100,fontSize:16,fontWeight: 'bold',};
        },
    },
    {
        id: 'lastCommitDay',
        type: DataType.String,
        header: 'Last Commit at',
        width:150,
        tdStyle() {
            return { textAlign:'center', fontFamily:'Helvetica',width:100,fontSize:16, };
        },
    },
];


export default class DataTable extends React.Component {



    render() {

        const tableStyle = {
            marginTop: 20,
            overflow: "auto",
        };

        return (
            <div style={tableStyle}>
                <Request
                    url = {URL + this.props.productName["value"]}
                    method ='get'
                    accept ='json'
                >
                    {
                        ({error, result, loading}) => {
                            if (loading) {
                                return <div align="center"><p align="center">loading...</p></div>;
                            } else {
                                return(
                                <div>
                                    <TacoTable columns={columns} data={result.body} />
                                </div>
                                )
                            }
                        }
                    }
                </Request>
            </div>
        );
    }
}