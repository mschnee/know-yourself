import { createServer, Server } from "http";
import { join } from "path";
import { pathToFileURL } from "url";

import express, { Application } from "express";
import { initialize } from "express-openapi";

export default class Service {
    private app: Application;
    private server: Server;

    public async boot () {
        this.app = express();
        this.server = createServer(this.app);
    }

    public async start () {
        initialize({
            app: this.app,
            apiDoc: {
                openapi: "3.0.0",
                info: {
                    title: "Know-Thyself Api",
                    version: "0.0.1"
                },
                paths: {}
            },
            paths: join(__dirname, "openapi"),
            pathsIgnore: /(\.controller.[tj]s$|__tests?__|lib\/)/
        });

        return new Promise(resolve =>
            this.server.listen(process.env.PORT || 3000, resolve)
        );
    }

    public async stop () {
        this.server.close();
    }
}
