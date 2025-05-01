      




Attempt to default pushed docker package to public instead of private...

```yaml
      # ATTRIBUTION-AI: ChatGPT o3 (high)  2025-05-01
      - name: Log in to GHCR
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      # ATTRIBUTION-AI: ChatGPT o3 (high)  2025-05-01
      #${{ github.repository_owner }}
      - uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.repository }}/runpod-pytorch-heavy:latest
          labels: |
            org.opencontainers.image.source=${{ github.server_url }}/${{ github.repository }}

      # WARNING: May be untested.
      ## ATTRIBUTION-AI: ChatGPT o3 (high)  2025-05-01
      ## ---- make GHCR package public ---------------------------------------
      #- name: Make GHCR package public
        ## run only on default branch pushes or manual runs that resulted in a successful push
        #if: success()
        #env:
          #GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        #run: |
          ## The gh CLI is available by default on GitHub-hosted runners
          ## PATCH /user/packages/container/{package_name}/visibility → {visibility: public}
          #gh api --method PATCH \
            #-H "Accept: application/vnd.github+json" \
            #/user/packages/container/runpod-pytorch-heavy/visibility \
            #-f visibility=public
```
