# docker-json-server

[JSON Server](https://github.com/typicode/json-server) provides REST
API mocking based on plain JSON.  This is a
[docker](https://hub.docker.com/) image that eases setup.

## Build ##

Build the base docker image with the following command

``` sh
docker build -t json-server .
```

## Usage

The recommended way to run this container looks like this:

```sh
docker run -d \
  -p 3000:3000 \
  -v /home/user/articles.json:/data/db.json \
  json-server
```

The above example exposes the JSON Server REST API on port 3000, so
that you can now browse to: http://localhost:3000/

This is a rather common setup following docker's conventions:

* `-d` will run a detached instance in the background
* `-p {OutsidePort}:80` will bind the webserver to the given outside port
* `-v {AbsolutePathToJsonFile}:/data/db.json` should be passed to mount the given JSON file into the container
* `json-server` the name of this docker image

### Help ###

You can supply any number of JSON Server arguments that will be passed through unmodified.

```sh
$ docker run -it --rm json-server --help
```

### Environment Variables ###

The following environment variables can be overriden to achieve different behaviour

| Name          | Description                                   | Default Value       |
|---------------|-----------------------------------------------|---------------------|
| `SERVER_JS`   | Custom server using `json-server` as a module | `/app/server.js`    |
| `DB_JSON`     | API database json                             | `/data/db.json`     |
| `ROUTES_JSON` | Custom routes                                 | `/data/routes.json` |
| `FILES_JS`    | Load custome data programmatically            | `/data/file.js`     |
| `HOST`        | Expose server on host                         | 0.0.0.0             |
| `PORT`        | Expose server on port                         | 3000                |

The presence of `SERVER_JS` will override `DB_JSON`, `ROUTES_JSON` &
`FILES_JS` and gets priority over the other environment variables.

Sample files for each of the these files are available in the
`/sample` folder in the container

### JSON source ###

If you mount a file to `/data/db.json` (as in the above example),
it will automatically be used as the plain JSON data source file.

A sample file could look like this:

```json
{
  "posts": [
    { "id": 1, "title": "json-server", "author": "typicode" },
    { "id": 2, "title": "Run json-server in Docker", "author": "xshyamx" }
  ],
  "comments": [
    { "id": 1, "body": "some comment", "postId": 1 },
    { "id": 2, "body": "This is awesome", "postId": 2 },
    { "id": 3, "body": "Meh!", "postId": 2 }
  ],
  "profile": { "name": "typicode" }
}
```

Which can be mounted to the default path for `DB_JSON`

```sh
docker run -d \
  -p 3000:3000 \
  -v /home/user/data.json:/data/db.json \
  json-server
```

or the `DB_JSON` environment variable can be overriden

```sh
docker run -d \
  -p 3000:3000 \
  -e DB_JSON=/sample/db.json
  json-server
```

### JS seed file ###

If you mount a file to `/data/file.js`, it will automatically be used as a JS seed file.

JSON Server expects JS files to export a function that returns an object.
Seed files are useful if you need to programmaticaly create a lot of data.

A sample file could look like this:

```js
module.exports = function() {
  var data = {};

  data.posts = [];
  data.posts.push({ id: 1, body: 'foo' });
  //...

  return data;
}
```
Which can be mounted as 

```sh
docker run -d \
  -p 3000:3000 \
  -v /home/user/index.js:/data/file.js
  json-server
```

or alternatively override the `FILES_JS` environment variable

```sh
docker run -d \
  -p 3000:3000 \
  -e FILES_JS=/sample/file.js
  json-server
```

### Custom Routes ###

If you mount a file to `/data/routes.json`, it will automatically be
used as the custom routes configuration.

A sample file could look like this:

```json
{
  "/posts/:id/comments": "/comments?postId=:id"
}
```

Which can be mounted to the default path for `ROUTES_JSON`

```sh
docker run -d \
  -p 3000:3000 \
  -v /home/user/data.json:/data/db.json \
  -v /home/user/routes.json:/data/routes.json \
  json-server
```

or the `ROUTES_JSON` environment variable can be overriden

```sh
docker run -d \
  -p 3000:3000 \
  -e DB_JSON=/sample/db.json
  -e ROUTES_JSON=/sample/routes.json
  json-server
```

### Custom Server ###

If you mount a file to `/app/server.js`, it will be used as a custom
server configuration where json-server is used as a module for a
custom server.

A sample file looks like

``` js
// server.js
const jsonServer = require('json-server')
const server = jsonServer.create()
const router = jsonServer.router('db.json')
const middlewares = jsonServer.defaults()

server.use(middlewares)
server.use(router)
const port = process.env.PORT || 3000
server.listen(port, () => {
  console.log('JSON Server is running on port', port)
})
```

Which can be mounted to the default path for `SERVER_JS`

```sh
docker run -d \
  -p 3000:3000 \
  -v /home/user/server.js:/app/server.js \
  json-server
```

or the `SERVER_JS` environment variable can be overriden

```sh
docker run -d \
  -p 3000:3000 \
  -e SERVER_JS=/sample/server.js
  json-server
```
