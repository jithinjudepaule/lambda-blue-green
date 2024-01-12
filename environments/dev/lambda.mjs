
console.log('Loading function');

export const handler = async (event, context) => {
    var response = {
        statusCode: 200,
        headers: {
            'Content-Type': 'text/html; charset=utf-8',
        },
        body: "<h1>Hello from Lambda! This is version 6</h1>",
    };

return response;  
  
};
