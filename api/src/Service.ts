import { createServer, Server } from 'http'

import express, { Application } from 'express'
import { initialize } from 'express-openapi'

export default class Service {
    private app: Application
    private server: Server

    public async boot() {
        this.app = express()
        this.server = createServer(this.app)
    }

    public async start() {
        return new Promise(resolve => this.server.listen(process.env.PORT || 3000, resolve))
    }

    public async stop() {
        this.server.close()
    }
}