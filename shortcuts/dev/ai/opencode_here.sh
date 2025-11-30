




_here_opencode() {
    cat << 'CZXWXcRMTo8EmM8i4d'

{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "opencode": {
      "options": {
        "apiKey": "{env:OPENCODE_API_KEY}"
      }
    }
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "Devstral-Small-2507-128k-virtuoso": {
          "name": "Devstral-Small-2507-128k-virtuoso"
        },
        "gpt-oss-20b-128k-virtuoso": {
          "name": "gpt-oss-20b-128k-virtuoso"
        },
        "NVIDIA-Nemotron-Nano-9B-v2-128k-virtuoso": {
          "name": "NVIDIA-Nemotron-Nano-9B-v2-128k-virtuoso"
        },
        "Llama-3-NeuralDaredevil-8B-abliterated-128k-virtuoso": {
          "name": "Llama-3-NeuralDaredevil-8B-abliterated-128k-virtuoso"
        },
        "Llama-3_3-Nemotron-Super-49B-v1_5-12k-virtuoso": {
          "name": "Llama-3_3-Nemotron-Super-49B-v1_5-12k-virtuoso"
        }
      }
    },
    "openrouter": {
      "options": {
        "apiKey": "{env:OPENROUTER_API_KEY}"
      },
      "models": {
        "moonshotai/kimi-k2-thinking": {
          "options": {
            "provider": {
              "sort": "throughput",
              "max_price": "15"
            }
          }
        },
        "openai/gpt-5.1-codex:online": {
          "options": {
            "provider": {
              "sort": "throughput",
              "max_price": "35"
            }
          }
        },
        "openai/gpt-5.1:online": {
          "options": {
            "provider": {
              "sort": "throughput",
              "max_price": "35"
            }
          }
        },
        "openai/gpt-5-pro:online": {
          "options": {
            "provider": {
              "sort": "throughput",
              "max_price": "200"
            }
          }
        },
        "openai/o3:online": {
          "options": {
            "provider": {
              "sort": "throughput",
              "max_price": "35"
            }
          }
        },
        "google/gemini-3-pro-preview:online": {
          "options": {
            "provider": {
              "sort": "throughput",
              "max_price": "25"
            }
          }
        },
        "deepseek/deepseek-r1-0528:online": {
          "options": {
            "provider": {
              "sort": "throughput",
              "max_price": "25"
            }
          }
        },
        "deepseek/deepseek-r1-0528": {
          "options": {
            "provider": {
              "sort": "throughput",
              "max_price": "25"
            }
          }
        },
        "nvidia/llama-3.1-nemotron-ultra-253b-v1:online": {
          "options": {
            "provider": {
              "sort": "throughput",
              "max_price": "25"
            }
          }
        },
        "nvidia/llama-3.1-nemotron-ultra-253b-v1": {
          "options": {
            "provider": {
              "sort": "throughput",
              "max_price": "25"
            }
          }
        },
        "openai/gpt-oss-120b": {
          "options": {
            "provider": {
              "sort": "latency",
              "order": ["Groq", "Cerebras", "Amazon Bedrock"],
              "max_price": "20"
            }
          }
        }
      }
    },
    "openai": {
      "options": {
        "apiKey": "{env:OPENAI_API_KEY}"
      }
    }
    "zenmux": {
      "options": {
        "apiKey": "{env:ZENMUX_API_KEY}"
      }
    }
  }
}

CZXWXcRMTo8EmM8i4d
}




