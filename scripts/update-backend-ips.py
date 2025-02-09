#!/usr/bin/env python3

import json
import os
import shlex
import subprocess


def update_v38_resources(backend_ips):
    local_version_command = 'weka version current'
    process = subprocess.Popen(shlex.split(local_version_command), stdout=subprocess.PIPE)
    output, stderr = process.communicate()
    if process.returncode != 0:
        print("Could not get current version")
        print("Return Code: {}".format(process.returncode))
        print("Output: {}".format(output))
        print("Stderr: {}".format(stderr))
        exit(1)

    resources_path = '/opt/weka/data/default_{}/container/resources.json'.format(output.decode('utf-8').strip())
    print("Editing the local resources in {}".format(resources_path))

    with open(resources_path, 'r') as json_file:
        data = json.load(json_file)
        data["backend_endpoints"] = []
        data["backend_endpoints"] = [{"ip": ip, "port": 14000} for ip in backend_ips]

    with open(resources_path, 'w') as json_file:
        json.dump(data, json_file)


def main():
    # Backing up resources without use of `weka local resources export` because on 3.8.1 it does not exist
    backup_file_name = os.path.abspath('resources.json.backup')
    if os.path.exists(backup_file_name):
        print("Backup resources file {} already exists, will not override it".format(backup_file_name))
        exit(1)

    backup_resources_command = '/bin/sh -c "weka local resources -J > {}"'.format(backup_file_name)
    print("Backing up resources to {}".format(os.path.abspath(backup_file_name)))
    process = subprocess.Popen(shlex.split(backup_resources_command), stdout=subprocess.PIPE)
    output, stderr = process.communicate()
    if process.returncode != 0:
        print("Something went wrong when backing up resources")
        print("Return Code: {}".format(process.returncode))
        print("Output: {}".format(output))
        print("Stderr: {}".format(stderr))
        exit(1)


    get_backends = "weka cluster host -b --json"
    print("Getting IPs of all backends from the cluster")
    process = subprocess.Popen(shlex.split(get_backends), stdout=subprocess.PIPE)
    json_bytes, stderr = process.communicate()
    if json_bytes == b'' or stderr is not None or process.returncode != 0:
        print("Bad JSON returned")
        exit(1)
    output = json.loads(json_bytes.decode('utf-8'))
    backend_ips = []
    for value in output:
        backend_ips += value["ips"]

    print("All backend IPs known by the cluster: {}".format(backend_ips))
    if backend_ips == []:
        print("No backend IPs found, will not try and set them in the resources")
        exit(1)


    set_backend_ips = 'weka local resources join-ips {}'.format(' '.join(backend_ips))
    print("Trying to set IPs of backends as join-ips using the following command: {}".format(set_backend_ips))
    # Pipe the output to /dev/null, to avoid showing off a scary display bug that displays that it set the ips to ", , , , "
    process = subprocess.Popen(shlex.split('/bin/sh -c "{} 2>/dev/null"'.format(set_backend_ips)), stdout=subprocess.PIPE)
    output, stderr = process.communicate()
    if process.returncode == 3:
        print("The local resources command for editing join-ips does not exist in this version, falling back to editing resources file")
        update_v38_resources(backend_ips)
    elif process.returncode != 0:
        print("Something went wrong with setting backend IPs")
        print("Return Code: {}".format(process.returncode))
        print("Output: {}".format(output))
        print("Stderr: {}".format(stderr))
        exit(1)

    apply_resources = 'weka local resources apply -f'
    print("Applying resources using local apply command")
    process = subprocess.Popen(shlex.split(apply_resources), stdout=subprocess.PIPE)
    output, stderr = process.communicate()
    if process.returncode != 0:
        print("Something went wrong with applying resources")
        print("Return Code: {}".format(process.returncode))
        print("Output: {}".format(output))
        print("Stderr: {}".format(stderr))
        exit(1)


    read_local_resources = 'weka local resources --json'
    print("IPs currently recorded in resources:")
    process = subprocess.Popen(shlex.split(read_local_resources), stdout=subprocess.PIPE)
    json_bytes, stderr = process.communicate()
    if json_bytes == b'' or stderr is not None or process.returncode != 0:
        print("Return Code: {}".format(process.returncode))
        print("Bad JSON returned")
        exit(1)
    output = json.loads(json_bytes.decode('utf-8'))
    for endpoint in output["backend_endpoints"]:
        print('\t{}:{}'.format(endpoint["ip"], endpoint["port"]))

    print("\nFinished setting backend IPs")


if '__main__' == __name__:
    main()
