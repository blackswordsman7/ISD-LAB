const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const web3 = new Web3(ganache.provider());

const { interface, bytecode } = require('../compile');

let TeamManagement;
let accounts;

beforeEach(async () => {
  accounts = await web3.eth.getAccounts();

  TeamManagement = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: bytecode })
    .send({ from: accounts[0], gas: '1000000' });
});

describe('TeamManagement Contract', () => {
  it('deploys a contract', () => {
    assert.ok(TeamManagement.options.address);
  });

  it('Creator of contract is assigned as the leader', async () => {
    await TeamManagement.methods.TeamManagement().send({
      from: accounts[0]
    });

    const leader = await TeamManagement.methods.TeamManagement().call({
      from: accounts[0]
    });

    assert.equal(accounts[0], leader);
    
  });

  it('creation of task', async () => {
    const create = await TeamManagement.methods.createTask().call();
    assert(create);
    });
    

  it('submission for work', async () => {
    try {
      await TeamManagement.methods.SubmitWork().call()({
        from: accounts[0],
        value: 0,
        taskId: _taskId
      });
      task = tasks[taskId]
      if(task.expireDate < system.datetime.now){
        const state = Teeammanagement.task.state
      }
      assert.equal(state, "SUBMITTED");
    } catch (err) {
      assert(err);
    }
  });

  it('Review of task by reviewer', async () => {
    try {
      await TeamManagement.methods.pickWinner().send({
        from: accounts[1]
        taskId: _taskId
      });
      task = tasks[taskId]
      if(task.expireDate < system.datetime.now){
        const state = Teeammanagement.task.state
      }
      assert.equal(state, "COMPLETED");
    } catch (err) {
      assert(err);
    }
  });

  it('deadline extension', async () => {
    await TeamManagement.methods.enter().send({
      from: accounts[0],
      value: web3.utils.toWei('2', 'ether')
    });
    task = tasks[taskId]
      if(task.expireDate < system.datetime.now){
        const state = Teeammanagement.task.state
      }
      assert.equal(state, "EXTENDED");
  });
});
