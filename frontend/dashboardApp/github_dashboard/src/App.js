import React from 'react';
import Header from "./components/Header";
import Footer from "./components/Footer";
import CardHolder from "./components/CardHolder";
import Title from "./components/Title";
import DataTable from "./components/DataTable";
import ProductSelect from "./components/ProductSelect"


class App extends React.Component {

  constructor() {
      super();
      this.state = {productName:"Ballerina"}
  }
  onChildChanged(newValue) {
      this.setState({ productName: newValue });
  }

  render() {
      const appStyle = {
          maxWidth: "100%",
          overflow: "hidden"
      };
    return (
            <div style={appStyle}>
                <Header/>
                <Title/>
                <CardHolder/>
                <ProductSelect callbackParent={(value) => this.onChildChanged(value) }/>
                <DataTable productName={this.state.productName}/>
                <Footer/>
            </div>
    );
  }
}

export default App;
