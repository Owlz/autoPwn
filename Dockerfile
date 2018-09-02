FROM shellphish/mechaphish

# --chown wasn't implemented until Docker 17.09. Dockerhub is still on 17.06.
# Change this back once Dockerhub catches up...
#COPY --chown=angr:angr . /home/angr/autoPwn/.
COPY . /home/angr/autoPwn/.
USER root
RUN chown -R angr:angr /home/angr/autoPwn && \
    dpkg -i /home/angr/autoPwn/gdb*.deb || apt-get install -fy && dpkg -i /home/angr/autoPwn/gdb*.deb

USER angr
RUN . /home/angr/.virtualenvs/angr/bin/activate && \
    pip install -U pip setuptools && \
    cd /home/angr/autoPwn/ && pip install -e . && \
    echo "autoPwn -h" >> ~/.bashrc && \
    echo "autoPwnCompile -h" >> ~/.bashrc && \
    mv /home/angr/autoPwn/gdbinit /home/angr/.gdbinit && \
    pip install angrgdb bintrees && \
    cd /home/angr && git clone --depth 1 --single-branch --branch docker-with-pie https://github.com/bannsec/patchkit.git && \
    echo "PATH=/home/angr/patchkit:\$PATH" >> ~/.bashrc

RUN ["/bin/bash"]
